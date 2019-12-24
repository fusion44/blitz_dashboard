import 'dart:async';
import 'package:blitz_gui/system/models/system_info.dart';
import 'package:bloc/bloc.dart';
import 'package:graphql/client.dart';
import './bloc.dart';

final String _getInfoQuery = r'''
{
  systemInfo {
    total_uptime
    total_uptime_idle
    mem_total
    mem_free
    mem_available
    temperature_c
    temperature_f
    hard_drive_total
    hard_drive_free
    hard_drive_usage
    network_interfaces{
      name
      ip4
      ip6
      rx
      tx
    }
  }
}
''';

class SystemInfoBloc extends Bloc<SystemInfoEvent, SystemInfoState> {
  final GraphQLClient _client;

  SystemInfoBloc(this._client);

  @override
  SystemInfoState get initialState => InitialSystemInfoState();

  @override
  Stream<SystemInfoState> mapEventToState(
    SystemInfoEvent event,
  ) async* {
    if (event is LoadSystemInfoEvent) {
      var res = await _client.query(
        QueryOptions(
          document: _getInfoQuery,
          fetchPolicy:
              event.useCache ? FetchPolicy.cacheFirst : FetchPolicy.networkOnly,
        ),
      );
      if (res.errors == null) {
        var info = SystemInfo.fromJson(res.data['systemInfo']);
        yield LoadedSystemInfoState(info);
      } else {
        yield LoadSystemInfoErrorState();
      }
    }
  }
}
