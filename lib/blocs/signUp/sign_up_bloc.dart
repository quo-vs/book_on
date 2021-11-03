import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../blocs/signUp/sign_up_event.dart';
import '../../blocs/signUp/sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<ValidateFieldsEvent>((event, emit) async {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState?.save();
        emit(ValidFields());
      } else {
        emit(SignUpFailreState(message: tr('fillRequiredFieldsError')));
      }
    });
  }
}