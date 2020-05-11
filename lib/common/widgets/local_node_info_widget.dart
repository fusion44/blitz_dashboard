import 'package:blitz_gui/lightning/lnd_rpc/lnd_rpc.dart';
import 'package:flutter/material.dart';

import '../../lightning/models/node_infos.dart';
import 'data_item.dart';
import 'mini_info_text_display.dart';

class LocalNodeInfoWidget extends StatefulWidget {
  final LocalNodeInfo info;
  final FeeReportResponse feeReport;
  final String header;

  LocalNodeInfoWidget(this.info, this.feeReport, this.header);

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
                subheader: 'a / i / p',
              ),
              message: 'Active / Inactive / Pending',
            ),
            Tooltip(
              child: MiniInfoTextDisplay(
                'Routing',
                _getRoutingText(),
                subheader: 'd / w / m',
              ),
              message: 'Daily / Weekly / Monthly',
            ),
          ],
        ),
      ],
    ));
  }

  String _getRoutingText() {
    var d = widget.feeReport.dayFeeSum.toString();
    var w = widget.feeReport.weekFeeSum.toString();
    var m = widget.feeReport.monthFeeSum.toString();

    return '$d / $w / $m';
  }
}
