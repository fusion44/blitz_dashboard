import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/widgets/mini_info_text_display.dart';
import 'blocs/info/bloc.dart';
import 'models/models.dart';

class BitcoinInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BlocBuilder(
      cubit: BlocProvider.of<BitcoinInfoBloc>(context),
      builder: (_, BitcoinInfoState state) {
        if (state is InitialBitcoinInfoState ||
            (state is LoadingBitcoinInfoState)) {
          return Center(child: Text('loading ...'));
        } else if (state is LoadedBitcoinInfoState) {
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Bitcoin',
                  style: theme.textTheme.headline2,
                  textAlign: TextAlign.center,
                ),
                _getPublicAddressRow(state.info, theme),
                Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: <Widget>[
                    MiniInfoTextDisplay(
                      'Network',
                      _getFullNetworkName(state.info),
                    ),
                    MiniInfoTextDisplay(
                      'Block Height',
                      '${state.info.blocks}',
                    ),
                    MiniInfoTextDisplay(
                      'Connections',
                      '${state.info.connections}',
                    ),
                    MiniInfoTextDisplay(
                      'Version',
                      state.info.subversion.split(':')[1].replaceAll('/', ''),
                    ),
                    MiniInfoTextDisplay(
                      'Chain Size',
                      '${(state.info.sizeOnDisk * 0.000000001).toStringAsFixed(1)}',
                      subheader: 'GB',
                    ),
                    MiniInfoTextDisplay(
                      'Mempool',
                      '${(state.info.mempoolBytes * 0.000001).toStringAsFixed(2)}',
                      subheader: 'MB',
                    ),
                    MiniInfoTextDisplay(
                      'Mempool',
                      '${state.info.mempoolTxCount}',
                      subheader: 'Transactions',
                    )
                  ],
                ),
              ],
            ),
          );
        } else if (state is LoadBitcoinInfoErrorState) {
          return Center(child: Card(child: Text(state.message)));
        } else {
          return Center(
            child: Card(
              child: Container(
                child: Text('I\'m confused! Unknown state: $state'),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _getPublicAddressRow(BitcoinInfo info, ThemeData theme) {
    var style = theme.textTheme.bodyText2.copyWith(fontSize: 25.0);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          info.localAddresses == null || info.localAddresses.isEmpty
              ? 'No public address'
              : 'Public Address: ',
          style: style,
        ),
        info.localAddresses == null || info.localAddresses.isEmpty
            ? Container()
            : Text(
                '${info.localAddresses[0].address}:${info.localAddresses[0].port}',
                style: style.copyWith(color: Colors.green),
              ),
      ],
    );
  }

  String _getFullNetworkName(BitcoinInfo info) {
    if (info.chain == 'main') {
      return 'Mainnet';
    } else if (info.chain == 'test') {
      return 'Testnet';
    } else {
      return 'Regtest';
    }
  }
}
