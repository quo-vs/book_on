import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  @override
  String toString() => 'Initial';
}

class AuthLoading extends AuthState {
  @override
  String toString() => 'Loading';
}

class AuthNotAuthenticated extends AuthState {
  @override
  String toString() => 'NotAuthenticated';
}


class AuthAuthenticated extends AuthState {
  final String displayName;

  AuthAuthenticated({ required this.displayName});

  @override
  String toString() => 
    'Authenticated { displayName: $displayName }';

  @override
  List<Object?> get props => [displayName];
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}