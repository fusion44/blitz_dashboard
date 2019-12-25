import 'dart:async';
import 'package:blitz_gui/bitcoind/models/models.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import 'package:graphql/client.dart';

final String _query = r'''
{
  bitcoinNetworkInfo {
    version
    subversion
    networkactive
    connections
    networks {
      name
      limited
      reachable
      proxy
      proxy_randomize_credentials
    }
    localaddresses {
      address
      port
      score
    }
  }
  bitcoinBlockchainInfo {
    chain
    blocks
    bestblockhash
    size_on_disk
  }
  bitcoinMempoolInfo {
    size
    bytes
    usage
  }
}
''';

class BitcoinInfoBloc extends Bloc<BitcoinInfoEvent, BitcoinInfoState> {
  final GraphQLClient _client;

  BitcoinInfoBloc(this._client);

  @override
  BitcoinInfoState get initialState => InitialBitcoinInfoState();

  @override
  Stream<BitcoinInfoState> mapEventToState(
    BitcoinInfoEvent event,
  ) async* {
    if (event is LoadBitcoinInfoEvent) {
      try {
        var res = await _client.query(
          QueryOptions(
            document: _query,
            fetchPolicy: event.useCache
                ? FetchPolicy.cacheFirst
                : FetchPolicy.networkOnly,
          ),
        );
        if (res.errors == null) {
          var combined = <String, dynamic>{};
          combined.addAll(res.data['bitcoinNetworkInfo']);
          combined.addAll(res.data['bitcoinBlockchainInfo']);
          combined.addAll(res.data['bitcoinMempoolInfo']);

          var info = BitcoinInfo.fromJson(combined);
          yield LoadedBitcoinInfoState(info);
        } else {
          print(res.errors);
          yield LoadBitcoinInfoErrorState(res.errors.toString());
        }
      } catch (e) {
        yield LoadBitcoinInfoErrorState(e.toString());
      }
    }
  }
}
