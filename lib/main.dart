import 'dart:async';
import 'dart:io';

import 'package:blitz_gui/system/system_info_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql/client.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'system/blocs/info/bloc.dart';

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
  GraphQLClient _gqlClient;

  SystemInfoBloc _systemInfoBloc;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  bool wantsToQuit = false;

  @override
  void initState() {
    // setup GraphQL client
    final _httpLink = HttpLink(uri: 'http://127.0.0.1:3000/graphql');

    _gqlClient = GraphQLClient(
      cache: InMemoryCache(),
      link: _httpLink,
    );

    _systemInfoBloc = SystemInfoBloc(_gqlClient);
    _systemInfoBloc.add(LoadSystemInfoEvent());

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
  }

  @override
  Widget build(BuildContext context) {
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
            ],
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[SystemInfoWidget()],
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
}
