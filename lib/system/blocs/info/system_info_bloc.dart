import 'dart:async';
import 'dart:io';
import 'package:blitz_gui/system/models/models.dart';
import 'package:blitz_gui/system/models/system_info.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

/// Checks the type of [ProcessResult] stdout and converts it
/// to a String no matter what and trims the resulting String.
String _getStdOut(ProcessResult res) {
  if (!(res.stdout is String)) {
    print('Warning: res.stdout was not a String. Casting to a String.');
  }
  return res.stdout.toString().trim();
}

class SystemInfoBloc extends Bloc<SystemInfoEvent, SystemInfoState> {
  @override
  SystemInfoState get initialState => InitialSystemInfoState();

  @override
  Stream<SystemInfoState> mapEventToState(
    SystemInfoEvent event,
  ) async* {
    if (event is LoadSystemInfoEvent) {
      var error = false;

      // cpu temp
      var res = await Process.run(
        'cat',
        ['/sys/class/thermal/thermal_zone0/temp'],
      );

      var tempC;
      var tempF;
      tempC = int.tryParse(_getStdOut(res));

      if (tempC != null) {
        tempC /= 1000;
        tempF = (tempC * 18 + 325) / 10;
      } else {
        print('Warning, unable to get cpu temp. Script output: ${res.stdout}');
      }

      // uptime
      res = await Process.run('cat', ['/proc/uptime']);
      var uptime = _getStdOut(res).split(' ');

      // memory
      var memTotal, memFree, memAvailable;
      res = await Process.run('cat', ['/proc/meminfo']);
      var mem = _getStdOut(res).split('\n');
      if (mem.length > 1) {
        mem = mem.sublist(0, 3);

        var spl = mem[0].split(' ');
        memTotal = int.parse(spl[spl.length - 2]);

        spl = mem[1].split(' ');
        memFree = int.parse(spl[spl.length - 2]);

        spl = mem[2].split(' ');
        memAvailable = int.parse(spl[spl.length - 2]);
      } else {
        print('Warning: unable to get meminfo.');
      }

      // hard drive usage
      res = await Process.run('df', []);
      var hdd = _getStdOut(res).split('\n');
      int hardDriveTotal, hardDriveFree, hardDriveUsagePercent;
      hdd.forEach((String line) {
        if (line.startsWith('/dev/sda')) {
          var spl = line.split(' ');
          spl.removeWhere((String item) => item.isEmpty);
          hardDriveTotal = int.tryParse(spl[1]);
          hardDriveFree = int.tryParse(spl[3]);
          hardDriveUsagePercent = int.tryParse(spl[4].replaceAll('%', ''));
        }
      });

      // network stats
      res = await Process.run('ifconfig', []);
      var interfaces = _getStdOut(res).split('\n');

      var networkInterfaces = <NetworkInterface>[];

      var iName, ip4, ip6, rx, tx;

      for (var i = 0; i < interfaces.length; i++) {
        var l = interfaces[i];
        if ((l.startsWith('eth') || l.startsWith('enp')) && l.contains('UP')) {
          try {
            iName = l.split(':')[0];
            ip4 = interfaces[i + 1].split('inet')[1].split('netmask')[0].trim();
            ip6 = interfaces[i + 2]
                .split('inet6')[1]
                .split('prefixlen')[0]
                .trim();
            rx = int.tryParse(
              interfaces[i + 4].split('bytes')[1].split('(')[0].trim(),
            );
            tx = int.tryParse(
              interfaces[i + 6].split('bytes')[1].split('(')[0].trim(),
            );

            networkInterfaces.add(
              NetworkInterface(
                name: iName,
                ip4: ip4,
                ip6: ip6,
                rx: rx,
                tx: tx,
              ),
            );
          } on RangeError catch (e) {
            print('Warning unable to get network interfaces: $e');
          }
        }
      }

      if (error) {
        yield LoadSystemInfoErrorState();
      } else {
        var info = SystemInfo(
          totalUptime: double.tryParse(uptime[0]),
          totalUptimeIdle: double.tryParse(uptime[1]),
          memTotal: memTotal,
          memFree: memFree,
          memAvailable: memAvailable,
          networkInterfaces: networkInterfaces,
          temperatureC: tempC,
          temperatureF: tempF,
          hardDriveTotal: hardDriveTotal,
          hardDriveFree: hardDriveFree,
          hardDriveUsage: hardDriveUsagePercent,
        );
        yield LoadedSystemInfoState(info);
      }
    }
  }
}
