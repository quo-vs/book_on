abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpFailreState extends SignUpState {
  String message;

  SignUpFailreState({required this.message});
}

class ValidFields extends SignUpState {}