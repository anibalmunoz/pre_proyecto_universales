import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'global_event.dart';
part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(AppStarted()) {
    on<DeslogueadoEvent>((event, emit) {
      emit(UsuarioDeslogueadoState(isLogueado: false));
    });

    on<LogueadoEvent>((event, emit) {
      emit(UsuarioDeslogueadoState(isLogueado: true));
    });
  }
}
