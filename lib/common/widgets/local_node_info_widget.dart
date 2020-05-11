import 'package:flutter/material.dart';

import '../../lightning/models/node_infos.dart';
import 'data_item.dart';
import 'mini_info_text_display.dart';

class LocalNodeInfoWidget extends StatefulWidget {
  final LocalNodeInfo info;
  final String header;

  LocalNodeInfoWidget(this.info, this.header);

  @override
  _LocalNodeInfoWidgetState createState() => _LocalNodeInfoWidgetState();
}

class _LocalNodeInfoWidgetState extends State<LocalNodeInfoWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var a = widget.info.numActiveChannels;
    var i = widget.info.numInactiveChannels;
    var p = widget.info.numPendingChannels;
    return Card(
        child: Column(
      children: <Widget>[
        Text(
          'Lightning',
          style: theme.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        DataItem(
          text: widget.info.identityPubkey,
          label: 'identity_pubkey',
        ),
        DataItem(
          text: widget.info.version,
          label: 'Version',
        ),
        Wrap(
          children: <Widget>[
            MiniInfoTextDisplay('Alias', widget.info.alias),
            MiniInfoTextDisplay(
              'Synced',
              widget.info.syncedToChain.toString(),
            ),
            MiniInfoTextDisplay('Peers', widget.info.numPeers.toString()),
            Tooltip(
              child: MiniInfoTextDisplay(
                'Channels',
                '$a / $i / $p',
              ),
              message: 'Active / Inactive / Pending',
            ),
            MiniInfoTextDisplay('Peers', widget.info.numPeers.toString()),
          ],
        ),
      ],
    ));
  }
}
