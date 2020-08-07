import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:path/path.dart' show dirname, join;

import 'common/connection_manager/bloc.dart';
import 'dashboard.dart';

void main() async {
  await DotEnv().load(join(
    dirname(Platform.script.path),
    '/home/admin/dev/.env',
  ));
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raspiblitz Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Raspiblitz Dashboard'),
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

  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  bool wantsToQuit = false;

  @override
  void initState() {
    _connectionManagerBloc = Get.put(ConnectionManagerBloc());
    _connectionManagerBloc.add(AppStart());
    super.initState();
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              wantsToQuit = true;
              _showLockScreen(context, opaque: false);
            },
          )
        ],
      ),
      body: Dashboard(),
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
            title: Text('Passcode'),
            passwordDigits: 4,
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.9),
            cancelCallback: _onPasscodeCancelled,
            cancelButton: FlatButton(
              onPressed: () => _onPasscodeCancelled,
              child: Text('Cancel'),
            ),
            deleteButton: FlatButton(
              onPressed: () => print('delete'),
              child: Text('delete'),
            ),
          );
        },
      ),
    );
  }

  void _onPasscodeEntered(String enteredPasscode) {
    var isValid = '1111' == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      if (wantsToQuit) {
        exit(0);
      }
    }
  }

  void _onPasscodeCancelled() {
    wantsToQuit = false;
  }
}
