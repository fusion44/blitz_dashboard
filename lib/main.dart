import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:path/path.dart' show dirname, join;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'bitcoind/bitcoin_info_widget.dart';
import 'bitcoind/blocs/info/bloc.dart';
import 'common/connection_manager/bloc.dart';
import 'lightning/blocs/ln_info_bloc/bloc.dart';
import 'lightning/lightning_info_widget.dart';
import 'system/blocs/info/bloc.dart';
import 'system/system_info_widget.dart';

void main() async {
  await DotEnv().load(join(dirname(Platform.script.path), '.env'));
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raspiblitz Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Raspiblitz V1.5'),
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
  ConnectionManagerBloc _connectionManagerBloc;
  LnInfoBloc _lnInfoBloc;
  SystemInfoBloc _systemInfoBloc;
  BitcoinInfoBloc _bitcoinInfoBloc;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  bool wantsToQuit = false;

  bool _systemInfoLoading = true;
  bool _btcNetInfoLoading = true;
  bool _lnInfoLoading = true;

  @override
  void initState() {
    _connectionManagerBloc = ConnectionManagerBloc();
    _connectionManagerBloc.add(AppStart());
    _lnInfoBloc = LnInfoBloc(_connectionManagerBloc);

    _systemInfoBloc = SystemInfoBloc();
    _systemInfoBloc.add(LoadSystemInfoEvent());

    _bitcoinInfoBloc = BitcoinInfoBloc();
    _bitcoinInfoBloc.add(LoadBitcoinInfoEvent());

    super.initState();
  }

  @override
  void dispose() {
    _systemInfoBloc.close();
    _verificationNotifier.close();
    super.dispose();
  }

  void _onRefresh() async {
    _systemInfoBloc.add(LoadSystemInfoEvent(useCache: false));
    _bitcoinInfoBloc.add(LoadBitcoinInfoEvent(useCache: false));
    _lnInfoBloc.add(LoadLnInfo());
    _systemInfoLoading = true;
    _btcNetInfoLoading = true;
    _lnInfoLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SystemInfoBloc, SystemInfoState>(
          bloc: _systemInfoBloc,
          listener: (_, state) {
            if (state is LoadedSystemInfoState ||
                state is LoadSystemInfoErrorState) {
              _systemInfoLoading = false;
              _checkLoadingState();
            }
          },
        ),
        BlocListener<BitcoinInfoBloc, BitcoinInfoState>(
          bloc: _bitcoinInfoBloc,
          listener: (_, state) {
            if (state is LoadedBitcoinInfoState ||
                state is LoadBitcoinInfoErrorState) {
              _btcNetInfoLoading = false;
              _checkLoadingState();
            }
          },
        ),
        BlocListener<LnInfoBloc, LnInfoState>(
          bloc: _lnInfoBloc,
          listener: (_, state) {
            if (state is LnInfoStateLoadingFinished) {
              _lnInfoLoading = false;
              _checkLoadingState();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  wantsToQuit = true;
                  _showLockScreen(context, opaque: false);
                })
          ],
        ),
        body: SmartRefresher(
          physics: AlwaysScrollableScrollPhysics(),
          enablePullDown: true,
          header: WaterDropMaterialHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SystemInfoBloc>.value(value: _systemInfoBloc),
              BlocProvider<BitcoinInfoBloc>.value(value: _bitcoinInfoBloc),
              BlocProvider<LnInfoBloc>.value(value: _lnInfoBloc),
            ],
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      top: 8.0,
                      right: 8.0,
                      bottom: 4.0,
                    ),
                    child: SystemInfoWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: BitcoinInfoWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: NodeOverviewWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLockScreen(
    BuildContext context, {
    bool opaque,
    CircleUIConfig circleUIConfig,
    KeyboardUIConfig keyboardUIConfig,
  }) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: opaque,
        pageBuilder: (context, animation, secondaryAnimation) {
          return PasscodeScreen(
            title: 'Passcode',
            passwordDigits: 4,
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelLocalizedText: 'Cancel',
            deleteLocalizedText: 'Delete',
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.9),
            cancelCallback: _onPasscodeCancelled,
          );
        },
      ),
    );
  }

  void _onPasscodeEntered(String enteredPasscode) {
    var isValid = '' == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      if (wantsToQuit) {
        exit(1);
      }
    }
  }

  void _onPasscodeCancelled() {
    wantsToQuit = false;
  }

  void _checkLoadingState() {
    if (!_systemInfoLoading && !_btcNetInfoLoading && !_lnInfoLoading) {
      _refreshController?.refreshCompleted();
    }
  }
}
