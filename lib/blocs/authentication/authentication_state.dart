import 'package:easy_localization/easy_localization.dart';

import '../../models/user.dart';

enum AuthState { firstRun, authenticated, unauthenticated }

class AuthenticationState {
  final AuthState authState;
  final User? user;
  final String? message;

  const AuthenticationState._(this.authState, {this.user, this.message});

  const AuthenticationState.authenticated(User user) 
    : this._(AuthState.authenticated, user: user);

  AuthenticationState.unauthenticated({String? message})
    : this._(AuthState.unauthenticated, message: message ?? tr('unauthenticated'));
  
  const AuthenticationState.onboarding() : this._(AuthState.firstRun);
}