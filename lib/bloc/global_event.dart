part of 'global_bloc.dart';

abstract class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object?> get props => [];
}

class DeslogueadoEvent extends GlobalEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class LogueadoEvent extends GlobalEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
