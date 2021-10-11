import 'package:equatable/equatable.dart';

abstract class SignupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignUpWithEmailButtonPressed extends SignupEvent {
  final String email;
  final String password;

  SignUpWithEmailButtonPressed({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}

class SignupWithGoogleButtonPressed extends SignupEvent {
  SignupWithGoogleButtonPressed();
}