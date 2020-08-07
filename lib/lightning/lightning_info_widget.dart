import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/widgets/local_node_info_widget.dart';
import 'blocs/ln_info_bloc/bloc.dart';

class NodeOverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: BlocProvider.of<LnInfoBloc>(context),
      builder: (BuildContext context, LnInfoState state) {
        if (state is LnInfoStateLoading) {
          return Text('Loading');
        } else if (state is LnInfoStateLoadingFinished) {
          return LocalNodeInfoWidget(
            state.infoResponse,
            state.feeReport,
            'Info',
          );
        }
        return Text('Unknown State? $state');
      },
    );
  }
}
