import 'dart:async';
import 'dart:io';

import 'package:blitz_gui/constants.dart';
import 'package:blitz_gui/info/bloc/bloc.dart';
import 'package:blitz_gui/info/bloc/models.dart';
import 'package:blitz_gui/models/bitcoind/bitcoin_network_info.dart';
import 'package:blitz_gui/widgets/charts/half_gauge_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'models/bitcoind/models.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raspiblitz Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Raspiblitz V1.3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading = true;
  BitcoinBlockChainInfo _blockChainInfo;
  BitcoinNetworkInfo _networkInfo;
  String _rpcUrl = '';
  SystemInfoBloc _systemInfoBloc = SystemInfoBloc();
  Completer<void> _refreshCompleter;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _systemInfoBloc.add(LoadSystemInfoEvent());
    _refreshCompleter = Completer<void>();
    super.initState();
  }

  @override
  void dispose() {
    _systemInfoBloc.close();
    super.dispose();
  }

  void _onRefresh() async {
    _systemInfoBloc.add(LoadSystemInfoEvent(useCache: false));
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocListener<SystemInfoBloc, SystemInfoState>(
      bloc: _systemInfoBloc,
      listener: (_, SystemInfoState state) {
        if (state is LoadedSystemInfoState) {
          _refreshController?.refreshCompleted();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: BlocBuilder(
          bloc: _systemInfoBloc,
          builder: (BuildContext context, SystemInfoState state) {
            if (state is InitialSystemInfoState ||
                (state is LoadingSystemInfoState)) {
              return Center(child: Text('loading ...'));
            } else if (state is LoadedSystemInfoState) {
              return SmartRefresher(
                physics: AlwaysScrollableScrollPhysics(),
                enablePullDown: true,
                header: WaterDropMaterialHeader(),
                controller: _refreshController,
                onRefresh: _onRefresh,
                child: _buildSingleChildScrollView(theme, state),
              );
            } else {
              return Center(child: Card(child: Text('I\'m confused!')));
            }
          },
        ),
      ),
    );
  }

  Widget _buildSingleChildScrollView(
      ThemeData theme, LoadedSystemInfoState state) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'System',
            style: theme.textTheme.display3,
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
              _getTrafficWidget(state.systemInfo.networkInterfaces, theme),
              _getUptimeWidget(state.systemInfo.totalUptime, theme)
            ],
          )
        ],
      ),
    );
  }

  _getTempChart(double temp, ThemeData theme) {
    MaterialColor c = Colors.green;
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

  _getMemChart(int total, int free, int available, ThemeData theme) {
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

  _getHDDChart(int total, int free, int used, ThemeData theme) {
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

  _getUptimeWidget(double uptime, ThemeData theme) {
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
                style: theme.textTheme.body1.copyWith(fontSize: 25.0)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              'Last reboot',
              style: theme.textTheme.display1,
            ),
          )
        ],
      ),
    );
  }

  _getTrafficWidget(List<NetworkInterface> interfaces, ThemeData theme) {
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
              style: theme.textTheme.display1.copyWith(fontSize: 20.0),
            ),
            SizedBox(height: 8.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(Icons.arrow_downward, color: Colors.green),
              SizedBox(width: 8.0),
              Text(
                '${((i.rx / 1024) / 1024).toStringAsFixed(2)} MB',
                style: theme.textTheme.body1.copyWith(fontSize: 25.0),
              )
            ]),
            SizedBox(height: 8.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Icon(Icons.arrow_upward, color: Colors.red),
              SizedBox(width: 8.0),
              Text(
                '${((i.tx / 1024) / 1024).toStringAsFixed(2)} MB',
                style: theme.textTheme.body1.copyWith(fontSize: 25.0),
              )
            ]),
            Text('Traffic', style: theme.textTheme.display1),
          ],
        ),
      );
    } else {
      return Text("Multiple network interfaces not implemented.");
    }
  }

  _getSSHLine(List<NetworkInterface> interfaces, ThemeData theme) {
    if (interfaces.length == 1) {
      var style = theme.textTheme.body1.copyWith(fontSize: 25.0);
      var i = interfaces[0];
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('ssh admin@', style: style),
          Text(
            i.ip4,
            style: style.copyWith(color: Colors.green),
          ),
        ],
      );
    } else {
      return Text("Multiple network interfaces not implemented.");
    }
  }
}
