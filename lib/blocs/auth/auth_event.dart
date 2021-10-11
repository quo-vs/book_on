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