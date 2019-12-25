import 'package:meta/meta.dart';

@immutable
abstract class BitcoinInfoEvent {
  const BitcoinInfoEvent();
}

class LoadBitcoinInfoEvent extends BitcoinInfoEvent {
  final bool useCache;

  LoadBitcoinInfoEvent({this.useCache = true});
}
