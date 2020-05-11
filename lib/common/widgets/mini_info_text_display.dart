import 'package:flutter/material.dart';

import '../../constants.dart';

class MiniInfoTextDisplay extends StatelessWidget {
  final String header;
  final String subheader;
  final String content;

  const MiniInfoTextDisplay(
    this.header,
    this.content, {
    this.subheader,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      width: miniInfoWidgetSize.width,
      height: miniInfoWidgetSize.height - 25,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: <Widget>[
            subheader != null
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Text(
                        subheader,
                        style:
                            theme.textTheme.bodyText1.copyWith(fontSize: 18.0),
                      ),
                    ),
                  )
                : Container(),
            Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      content,
                      style: theme.textTheme.headline3
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text(header, style: theme.textTheme.headline4),
              ],
            )
          ],
        ),
      ),
    );
  }
}
