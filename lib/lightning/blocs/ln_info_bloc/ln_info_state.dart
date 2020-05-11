import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../lnd_rpc/lnd_rpc.dart';
import '../../models/node_infos.dart';

@immutable
abstract class LnInfoState extends Equatable {}

class InitialLnInfoState extends LnInfoState {
  @override
  List<Object> get props => const [];
}

class LnInfoStateLoading extends LnInfoState {
  @override
  List<Object> get props => const [];
}

class LnInfoStateReloading extends LnInfoState {
  final LocalNodeInfo infoResponse;
  final WalletBalanceResponse walletBalance;
  final ChannelBalanceResponse channelBalance;

  LnInfoStateReloading(
    this.infoResponse,
    this.walletBalance,
    this.channelBalance,
  );

  @override
  List<Object> get props => [infoResponse, walletBalance, channelBalance];
}

class LnInfoStateLoadingFinished extends LnInfoState {
  final LocalNodeInfo infoResponse;
  final WalletBalanceResponse walletBalance;
  final ChannelBalanceResponse channelBalance;
  final FeeReportResponse feeReport;

  LnInfoStateLoadingFinished(
    this.infoResponse,
    this.walletBalance,
    this.channelBalance,
    this.feeReport,
  );

  @override
  List<Object> get props => [
        infoResponse,
        walletBalance,
        channelBalance,
        feeReport,
      ];
}
