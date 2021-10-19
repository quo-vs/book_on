import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class AuthEvent extends Equatable {

  @override
  List<Object?> get props => [];
}

class AppStarted extends AuthEvent {

  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthEvent {
  final String displayName;

  LoggedIn({ required this.displayName});

  @override
  List<Object?> get props => [displayName];
}

class SignedUp extends AuthEvent {
  final String displayName;

  SignedUp({ required this.displayName});

  @override
  List<Object?> get props => [displayName];
}

class LoggedOut extends AuthEvent {
}


class LoginWithEmailButtonPressed extends AuthEvent {
  final String email;
  final String password;

  LoginWithEmailButtonPressed({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}

class LoginWithGoogleButtonPressed extends AuthEvent {
  LoginWithGoogleButtonPressed();
}

class LoginAnonymouslyButtonPressed extends AuthEvent {
  LoginAnonymouslyButtonPressed();
}

class SignUpWithEmailButtonPressed extends AuthEvent {
  final String email;
  final String password;

  SignUpWithEmailButtonPressed({
    required this.email,
    required this.password
  });

  @override
  List<Object?> get props => [email, password];
}

class SignupWithGoogleButtonPressed extends AuthEvent {
  SignupWithGoogleButtonPressed();
}