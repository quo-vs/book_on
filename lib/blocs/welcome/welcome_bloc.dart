import 'package:bloc/bloc.dart';
import '../../blocs/welcome/welcome_event.dart';
import '../../blocs/welcome/welcome_state.dart';

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeInitial()) {
    on<LoginPressed>((event, emit) {
      emit(WelcomeInitial(pressTarget: WelcomePressTarget.login));
    });

    on<SignupPressed>((event, emit) {
      emit(WelcomeInitial(pressTarget: WelcomePressTarget.signup));
    });

    on<ExporeAsGuestPressed>((event, emit) {
      emit(WelcomeInitial(pressTarget: WelcomePressTarget.guest));
    });
  }
}
