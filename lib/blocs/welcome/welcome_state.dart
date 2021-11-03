enum WelcomePressTarget { login, signup, guest }

abstract class WelcomeState {}

class WelcomeInitial extends WelcomeState {
  WelcomePressTarget? pressTarget;

  WelcomeInitial({this.pressTarget});
}