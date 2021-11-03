abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ValidResetPasswordFiels extends ResetPasswordState {}

class ResetPasswordFailureState extends ResetPasswordState {
  String message;

  ResetPasswordFailureState({required this.message});
}

class ResetPasswordDone extends ResetPasswordState {}