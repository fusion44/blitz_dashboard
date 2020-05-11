import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:convert/convert.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grpc/grpc.dart';

import '../../lightning/lnd_rpc/lnd_rpc.dart';
import '../../lightning/models/lnd_connection_data.dart';
import '../utils.dart';
import 'connection_data_provider.dart';
import 'connection_manager_event.dart';
import 'connection_manager_state.dart';

class ConnectionManagerBloc
    extends Bloc<ConnectionManagerEvent, ConnectionManagerState> {
  ClientChannel _clientChannel;
  LightningClient _lightningClient;
  StreamSubscription _prefsSubscription;

  LndConnectionData _currentActiveConnection;

  @override
  ConnectionManagerState get initialState => InitialConnectionManagerState();

  @override
  Future<void> close() async {
    await _prefsSubscription.cancel();
    await _clientChannel.shutdown();
    await super.close();
  }

  @override
  Stream<ConnectionManagerState> mapEventToState(
    ConnectionManagerEvent event,
  ) async* {
    if (event is AppStart) {
      await _establishConnection();
      yield ConnectionEstablishedState();
    }
  }

  void _establishConnection() async {
    _currentActiveConnection = LndConnectionData(
      name: 'LND1',
      certificate: _prepareCertificate(DotEnv().env['lnd_certificate']),
      macaroon: _prepareMacaroon(DotEnv().env['lnd_macaroon']),
      host: DotEnv().env['lnd_host'],
      port: int.parse(DotEnv().env['lnd_port']),
    );

    var creds = ChannelCredentials.secure(
      certificates: _currentActiveConnection.certificate,
      onBadCertificate: (X509Certificate certificate, String host) => true,
    );

    var opts = ChannelOptions(credentials: creds);
    _clientChannel = ClientChannel(
      _currentActiveConnection.host,
      port: _currentActiveConnection.port,
      options: opts,
    );

    _lightningClient = LightningClient(
      _clientChannel,
      options: CallOptions(
        metadata: {'macaroon': _currentActiveConnection.macaroon},
      ),
    );

    LnConnectionDataProvider().channel = _clientChannel;
    LnConnectionDataProvider().macaroon = _currentActiveConnection.macaroon;
    LnConnectionDataProvider().lightningClient = _lightningClient;
  }

  List<int> _prepareCertificate(String certificate) {
    var cert = certificate.replaceAll(r'-', '+');
    cert = cert.replaceAll(r'_', '/');

    // The certificate must be power of 4 in length
    // Base64 defined '=' as the filler character
    cert = fillString(cert);

    cert = '''
-----BEGIN CERTIFICATE-----
$cert
-----END CERTIFICATE-----
''';

    return utf8.encode(cert);
  }

  String _prepareMacaroon(String macaroon) {
    var m = macaroon.replaceAll(r'-', '+');
    m = m.replaceAll(r'_', '/');
    m = fillString(macaroon);
    m = hex.encode(base64.decode(m));
    return m;
  }
}
