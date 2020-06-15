import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'pages/info_page.dart';

double width = 200;
double height = 200;

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Wrap(children: [
        _buildDashButton(
          theme: theme,
          text: 'INFO',
          icon: Icons.offline_bolt,
          onPressed: () => Get.to(InfoPage()),
        ),
        _buildDashButton(
          theme: theme,
          text: 'RECEIVE',
          icon: Icons.arrow_downward,
          iconColor: Colors.greenAccent,
          onPressed: notImplementedSnackbar,
        ),
        _buildDashButton(
          theme: theme,
          text: 'SEND',
          icon: Icons.arrow_upward,
          iconColor: Colors.redAccent,
          onPressed: notImplementedSnackbar,
        ),
        _buildDashButton(
          theme: theme,
          text: 'CHAT',
          icon: Icons.chat,
          onPressed: notImplementedSnackbar,
        ),
        _buildDashButton(
          theme: theme,
          text: 'SETTINGS',
          icon: Icons.settings,
          onPressed: notImplementedSnackbar,
        ),
      ]),
    );
  }

  void notImplementedSnackbar() {
    Get.snackbar(
      'Not implemented',
      'Please wait or submit a pull request :)',
      messageText: Text('Please wait or submit a pull request :)'),
      borderRadius: 5,
      animationDuration: Duration(milliseconds: 200),
      icon: Icon(Icons.error),
      backgroundColor: Colors.black,
    );
  }

  Container _buildDashButton({
    ThemeData theme,
    String text,
    IconData icon,
    Color iconColor,
    Function onPressed,
  }) {
    return Container(
      width: width,
      height: height,
      child: Card(
        child: Column(
          children: [
            IconButton(
              iconSize: width - 70,
              icon: Icon(icon),
              color: iconColor,
              onPressed: onPressed,
            ),
            Text(text, style: theme.textTheme.headline5),
          ],
        ),
      ),
    );
  }
}
