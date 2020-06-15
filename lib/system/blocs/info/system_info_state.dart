import 'package:equatable/equatable.dart';

import '../../models/system_info.dart';

abstract class SystemInfoState extends Equatable {
  const SystemInfoState();
}

class InitialSystemInfoState extends SystemInfoState {
  @override
  List<Object> get props => [];
}

class LoadingSystemInfoState extends SystemInfoState {
  @override
  List<Object> get props => [];
}

class LoadedSystemInfoState extends SystemInfoState {
  final SystemInfo systemInfo;

  LoadedSystemInfoState(this.systemInfo);

  @override
  List<Object> get props => [systemInfo.hashCode];
}

class LoadSystemInfoErrorState extends SystemInfoState {
  @override
  List<Object> get props => [];
}
