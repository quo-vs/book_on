abstract class AuthenticationEvent {}

class LoginWithEmailAndPasswordEvent extends AuthenticationEvent {
  String email;
  String password;

  LoginWithEmailAndPasswordEvent({required this.email, required this.password});
}

class LoginAsGuest extends AuthenticationEvent {}

class SignupWithEmailAndPasswordEvent extends AuthenticationEvent {
  String email;
  String password;
  String? name;

  SignupWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
    this.name
  });
}

class LogoutEvent extends AuthenticationEvent {
  LogoutEvent();
}

class FinishedOnBoardingEvent extends AuthenticationEvent { }

class CheckFirstRunEvent extends AuthenticationEvent { }

