import 'package:blitz_gui/bitcoind/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class BitcoinInfoState extends Equatable {}

class InitialBitcoinInfoState extends BitcoinInfoState {
  @override
  List<Object> get props => [];
}

class LoadingBitcoinInfoState extends BitcoinInfoState {
  @override
  List<Object> get props => [];
}

class LoadedBitcoinInfoState extends BitcoinInfoState {
  final BitcoinInfo info;

  LoadedBitcoinInfoState(this.info);

  @override
  List<Object> get props => [
        info.hashCode,
        info.connections,
        info.mempoolBytes,
      ];
}

class LoadBitcoinInfoErrorState extends BitcoinInfoState {
  final String message;

  LoadBitcoinInfoErrorState(this.message);
  @override
  List<Object> get props => [message];
}
