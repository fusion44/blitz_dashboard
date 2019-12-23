import 'package:equatable/equatable.dart';
import 'package:blitz_gui/info/bloc/models.dart';

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
  List<Object> get props => [this.systemInfo.hashCode];
}

class LoadSystemInfoErrorState extends SystemInfoState {
  @override
  List<Object> get props => [];
}
