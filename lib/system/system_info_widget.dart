import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../common/widgets/charts/half_gauge_chart.dart';
import '../constants.dart';
import 'blocs/info/bloc.dart';
import 'models/models.dart';

class SystemInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder(
      bloc: BlocProvider.of<SystemInfoBloc>(context),
      builder: (_, SystemInfoState state) {
        if (state is InitialSystemInfoState ||
            (state is LoadingSystemInfoState)) {
          return Center(child: Text('loading ...'));
        } else if (state is LoadedSystemInfoState) {
          return Card(
            child: Column(
              children: <Widget>[
                Text(
                  'System',
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: <Widget>[
                    _getSSHLine(state.systemInfo.networkInterfaces, theme),
                    _getTempChart(state.systemInfo.temperatureC, theme),
                    _getMemChart(
                      state.systemInfo.memTotal,
                      state.systemInfo.memFree,
                      state.systemInfo.memAvailable,
                      theme,
                    ),
                    _getHDDChart(
                      state.systemInfo.hardDriveTotal,
                      state.systemInfo.hardDriveFree,
                      state.systemInfo.hardDriveUsage,
                      theme,
                    ),
                    _getTrafficWidget(
                      state.systemInfo.networkInterfaces,
                      theme,
                    ),
                    _getUptimeWidget(state.systemInfo.totalUptime, theme)
                  ],
                ),
              ],
            ),
          );
        } else {
          return Center(child: Card(child: Text('I\'m confused!')));
        }
      },
    );
  }

  Widget _getTempChart(double temp, ThemeData theme) {
    var c = Colors.green;
    if (temp > 75) {
      c = Colors.yellow;
    }
    if (temp > 85) {
      c = Colors.red;
    }
    final data = <GaugeSegment>[
      GaugeSegment('Temp', temp, c),
      GaugeSegment('Max', 120.0 - temp, Colors.grey),
    ];

    return HalfGaugeChart.fromSegments(
      data,
      'CPU Temp',
      '${temp.toStringAsFixed(1)} °C',
    );
  }

  Widget _getMemChart(int total, int free, int available, ThemeData theme) {
    var totalGi = ((total / 1024.0) / 1024.0).toStringAsFixed(1);
    var usedGi = (((total - available) / 1024.0) / 1024.0).toStringAsFixed(1);

    final data = <GaugeSegment>[
      GaugeSegment('Used', (total - available).toDouble(), Colors.green),
      GaugeSegment('Available', available.toDouble(), Colors.grey),
    ];

    return HalfGaugeChart.fromSegments(
      data,
      'Used Memory',
      '  $usedGi /\n$totalGi Gi',
      valueLines: 2,
    );
  }

  Widget _getHDDChart(int total, int free, int used, ThemeData theme) {
    var totalGi = ((total / 1024.0) / 1024.0).toStringAsFixed(1);
    var usedGi = (((total - free) / 1024.0) / 1024.0).toStringAsFixed(1);

    final data = <GaugeSegment>[
      GaugeSegment('Used', used.toDouble(), Colors.green),
      GaugeSegment('Available', (100 - used).toDouble(), Colors.grey),
    ];

    return HalfGaugeChart.fromSegments(
      data,
      'Used Disk',
      ' $usedGi /\n $totalGi Gi',
      valueLines: 2,
    );
  }

  Widget _getUptimeWidget(double uptime, ThemeData theme) {
    var dur = Duration(seconds: uptime.toInt());
    var up = timeago.format(DateTime.now().subtract(dur));
    return Container(
      width: miniInfoWidgetSize.width,
      height: miniInfoWidgetSize.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Text('$up',
                style: theme.textTheme.bodyText2.copyWith(fontSize: 25.0)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'Last reboot',
              style: theme.textTheme.headline4,
            ),
          )
        ],
      ),
    );
  }

  Widget _getTrafficWidget(List<NetworkInterface> interfaces, ThemeData theme) {
    if (interfaces == null || interfaces.isEmpty) {
      return Container();
    } else if (interfaces.length == 1) {
      var i = interfaces[0];
      return Container(
        width: miniInfoWidgetSize.width,
        height: miniInfoWidgetSize.height,
        child: Column(
          children: <Widget>[
            Text(
              i.name,
              style: theme.textTheme.headline4.copyWith(fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(Icons.arrow_downward, color: Colors.green),
              SizedBox(width: 8.0),
              Text(
                '${((i.rx / 1024) / 1024).toStringAsFixed(2)} MB',
                style: theme.textTheme.headline4.copyWith(fontSize: 25.0),
              )
            ]),
            SizedBox(height: 8.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(Icons.arrow_upward, color: Colors.red),
              SizedBox(width: 8.0),
              Text(
                '${((i.tx / 1024) / 1024).toStringAsFixed(2)} MB',
                style: theme.textTheme.bodyText2.copyWith(fontSize: 25.0),
              )
            ]),
            Text('Traffic', style: theme.textTheme.headline4),
          ],
        ),
      );
    } else {
      return Text('GUI for Multiple network interfaces not implemented, yet.');
    }
  }

  Widget _getSSHLine(List<NetworkInterface> interfaces, ThemeData theme) {
    if (interfaces.length == 1) {
      var style = theme.textTheme.bodyText2.copyWith(fontSize: 25.0);
      var i = interfaces[0];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('ssh admin@', style: style),
            Text(
              i.ip4,
              style: style.copyWith(color: Colors.green),
            ),
          ],
        ),
      );
    } else {
      return Text('Multiple network interfaces not implemented.');
    }
  }
}
