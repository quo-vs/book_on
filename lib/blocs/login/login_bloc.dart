import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../blocs/login/login_event.dart';
import '../../blocs/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<ValidateLoginFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(ValidLoginFields());
      } else {
        emit(LoginFailureState(errorMessage: tr('fillRequiredFieldsError')));
      }
    });
  }  
}