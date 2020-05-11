import 'package:fixnum/fixnum.dart';

import '../../lnd_rpc/lnd_rpc.dart' as grpc;
import '../remote_node_info.dart';
import 'channel.dart';
import 'pending_channel_data.dart';
import 'pending_htlcs.dart';

/// Channel pending force closing
class PendingForceClosingChannel extends Channel {
  /// The pending channel to be force closed
  final PendingChannelData channel;

  ///	The transaction id of the closing transaction
  final String closingTxid;

  ///	The balance in satoshis encumbered in this pending channel
  final Int64 limboBalance;

  /// The height at which funds can be swept into the wallet
  final int maturityHeight;

  /// Remaining # of blocks until the commitment output can
  /// be swept. Negative values indicate how many blocks
  /// have passed since becoming mature.
  final int blocksTilMaturity;

  /// The total value of funds successfully recovered from this
  /// channel
  final Int64 recoveredBalance;

  /// Pending HTLCs of the channel
  final List<PendingHtlc> pendingHtlcs;

  PendingForceClosingChannel({
    this.channel,
    this.closingTxid,
    this.limboBalance,
    this.maturityHeight,
    this.blocksTilMaturity,
    this.recoveredBalance,
    this.pendingHtlcs,
    RemoteNodeInfo remoteNodeInfo,
  }) : super(channel.channelPoint, remoteNodeInfo);

  static PendingForceClosingChannel fromGRPC(
    grpc.PendingChannelsResponse_ForceClosedChannel fcc, [
    RemoteNodeInfo remoteNodeInfo,
  ]) {
    List<PendingHtlc> pendingHtlcs;
    if (fcc.pendingHtlcs.isNotEmpty) {
      pendingHtlcs = [];
      fcc.pendingHtlcs.forEach(
        (htlc) {
          pendingHtlcs.add(PendingHtlc.fromGRPC(htlc));
        },
      );
    }

    PendingChannelData channel;
    if (fcc.channel != null) channel = PendingChannelData.fromGRPC(fcc.channel);

    return PendingForceClosingChannel(
      channel: channel,
      closingTxid: fcc.closingTxid,
      limboBalance: fcc.limboBalance,
      maturityHeight: fcc.maturityHeight,
      blocksTilMaturity: fcc.blocksTilMaturity,
      recoveredBalance: fcc.recoveredBalance,
      pendingHtlcs: pendingHtlcs,
      remoteNodeInfo: remoteNodeInfo,
    );
  }
}
