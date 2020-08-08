import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './bloc.dart';
import '../../models/models.dart';

FutureOr<Map<String, dynamic>> _getBlockchainInfo() async {
  var res = await Process.run(
    'bitcoin-cli',
    ['--conf=${DotEnv().env['bitcoin_config']}', 'getblockchaininfo'],
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
    ['--conf=${DotEnv().env['bitcoin_config']}', 'getmempoolinfo'],
  );

  var obj = json.decode(res.stdout.toString());

  return obj is Map<String, dynamic> ? obj : {};
}

FutureOr<Map<String, dynamic>> _getNetworkInfo() async {
  var res = await Process.run(
    'bitcoin-cli',
    [
      '--conf=${DotEnv().env['bitcoin_config']}',
      'getnetworkinfo',
    ],
  );

  var obj = json.decode(res.stdout.toString());

  return obj is Map<String, dynamic> ? obj : {};
}

class BitcoinInfoBloc extends Bloc<BitcoinInfoEvent, BitcoinInfoState> {
  BitcoinInfoBloc() : super(InitialBitcoinInfoState());

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
