import 'package:equatable/equatable.dart';

abstract class SystemInfoEvent extends Equatable {
  const SystemInfoEvent();
}

class LoadSystemInfoEvent extends SystemInfoEvent {
  final bool useCache;

  LoadSystemInfoEvent({this.useCache = true});

  @override
  List<Object> get props => [];
}
