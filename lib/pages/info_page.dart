import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../bitcoind/bitcoin_info_widget.dart';
import '../bitcoind/blocs/info/bloc.dart';
import '../lightning/blocs/ln_info_bloc/bloc.dart';
import '../lightning/lightning_info_widget.dart';
import '../system/blocs/info/bloc.dart';
import '../system/system_info_widget.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  LnInfoBloc _lnInfoBloc;
  SystemInfoBloc _systemInfoBloc;
  BitcoinInfoBloc _bitcoinInfoBloc;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool _systemInfoLoading = true;
  bool _btcNetInfoLoading = true;
  bool _lnInfoLoading = true;

  @override
  void initState() {
    _lnInfoBloc = LnInfoBloc(Get.find());

    _systemInfoBloc = SystemInfoBloc();
    _systemInfoBloc.add(LoadSystemInfoEvent());

    _bitcoinInfoBloc = BitcoinInfoBloc();
    _bitcoinInfoBloc.add(LoadBitcoinInfoEvent());

    super.initState();
  }

  @override
  void dispose() {
    _systemInfoBloc.close();
    super.dispose();
  }

  void _onRefresh() async {
    _systemInfoBloc.add(LoadSystemInfoEvent(useCache: false));
    _bitcoinInfoBloc.add(LoadBitcoinInfoEvent(useCache: false));
    _lnInfoBloc.add(LoadLnInfo());
    _systemInfoLoading = true;
    _btcNetInfoLoading = true;
    _lnInfoLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SystemInfoBloc, SystemInfoState>(
          cubit: _systemInfoBloc,
          listener: (_, state) {
            if (state is LoadedSystemInfoState ||
                state is LoadSystemInfoErrorState) {
              _systemInfoLoading = false;
              _checkLoadingState();
            }
          },
        ),
        BlocListener<BitcoinInfoBloc, BitcoinInfoState>(
          cubit: _bitcoinInfoBloc,
          listener: (_, state) {
            if (state is LoadedBitcoinInfoState ||
                state is LoadBitcoinInfoErrorState) {
              _btcNetInfoLoading = false;
              _checkLoadingState();
            }
          },
        ),
        BlocListener<LnInfoBloc, LnInfoState>(
          cubit: _lnInfoBloc,
          listener: (_, state) {
            if (state is LnInfoStateLoadingFinished) {
              _lnInfoLoading = false;
              _checkLoadingState();
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Raspiblitz Info'),
        ),
        body: SmartRefresher(
          physics: AlwaysScrollableScrollPhysics(),
          enablePullDown: true,
          header: WaterDropMaterialHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<SystemInfoBloc>.value(value: _systemInfoBloc),
              BlocProvider<BitcoinInfoBloc>.value(value: _bitcoinInfoBloc),
              BlocProvider<LnInfoBloc>.value(value: _lnInfoBloc),
            ],
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8.0,
                      top: 8.0,
                      right: 8.0,
                      bottom: 4.0,
                    ),
                    child: SystemInfoWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: BitcoinInfoWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: NodeOverviewWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkLoadingState() {
    if (!_systemInfoLoading && !_btcNetInfoLoading && !_lnInfoLoading) {
      _refreshController?.refreshCompleted();
    }
  }
}
