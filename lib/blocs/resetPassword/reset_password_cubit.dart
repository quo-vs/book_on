import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../blocs/resetPassword/reset_password_state.dart';
import '../../services/authentication_service.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  resetPassword(String email) async {
    await AuthenticationService.resetPassword(email);
    emit(ResetPasswordDone());
  }

  checkValidField(GlobalKey<FormState> key) {
    if (key.currentState?.validate() ?? false) {
      key.currentState!.save();
      emit(ValidResetPasswordFiels());
    } else {
      emit(ResetPasswordFailureState(message: tr('email_bad_format_error')));
    }
  }
}