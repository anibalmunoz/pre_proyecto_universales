part of 'global_bloc.dart';

abstract class GlobalState {
  // const GlobalState();

  // @override
  // List<Object> get props => [];
  bool isLogueado = false;

  bool get isAllGranted => isLogueado;

  cambiarlogueado() {
    this.isLogueado = !this.isLogueado;
  }
}

class AppStarted extends GlobalState {}

//class GlobalInitial extends GlobalState {}

class UsuarioLogueado extends GlobalState {}

class UsuarioDeslogueadoState extends GlobalState {
  final bool isLogueado;

  bool get isAllGranted => isLogueado;

  UsuarioDeslogueadoState({
    required this.isLogueado,
  });

  UsuarioDeslogueadoState copyWith({
    bool? isLogueado,
  }) =>
      UsuarioDeslogueadoState(
        isLogueado: isLogueado ?? this.isLogueado,
      );
}
