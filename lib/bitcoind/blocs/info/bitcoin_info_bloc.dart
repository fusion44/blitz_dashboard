import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:blitz_gui/bitcoind/models/models.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';

FutureOr<Map<String, dynamic>> _getBlockchainInfo() async {
  var res = await Process.run(
    'bitcoin-cli',
    [
      // '--conf=/mnt/btc/bitcoin/bitcoin_main.conf',
      'getblockchaininfo',
    ],
  );

  var obj = json.decode(res.stdout.toString());

  var newSoftforks = [];
  if (obj['softforks'] != null) {
    obj['softforks'].forEach((key, value) {
      value['name'] = key;
      newSoftforks.add(value);
    });
  }

  obj['softforks'] = newSoftforks;

  // return obj;
  return obj is Map<String, dynamic> ? obj : {};
}

FutureOr<Map<String, dynamic>> _getMempoolInfo() async {
  var res = await Process.run(
    'bitcoin-cli',
    [
      // '--conf=/mnt/btc/bitcoin/bitcoin_main.conf',
      'getmempoolinfo',
    ],
  );

  var obj = json.decode(res.stdout.toString());

  return obj is Map<String, dynamic> ? obj : {};
}

FutureOr<Map<String, dynamic>> _getNetworkInfo() async {
  var res = await Process.run(
    'bitcoin-cli',
    [
      // '--conf=/mnt/btc/bitcoin/bitcoin_main.conf',
      'getnetworkinfo',
    ],
  );

  var obj = json.decode(res.stdout.toString());

  return obj is Map<String, dynamic> ? obj : {};
}

class BitcoinInfoBloc extends Bloc<BitcoinInfoEvent, BitcoinInfoState> {
  @override
  BitcoinInfoState get initialState => InitialBitcoinInfoState();

  @override
  Stream<BitcoinInfoState> mapEventToState(
    BitcoinInfoEvent event,
  ) async* {
    if (event is LoadBitcoinInfoEvent) {
      try {
        var a = await _getNetworkInfo();
        var b = await _getBlockchainInfo();
        var c = await _getMempoolInfo();
        var combined = <String, dynamic>{};
        combined.addAll(a);
        combined.addAll(b);
        combined.addAll(c);

        var info = BitcoinInfo.fromJson(combined);
        yield LoadedBitcoinInfoState(info);
      } catch (e) {
        yield LoadBitcoinInfoErrorState(e.toString());
      }
    }
  }
}
