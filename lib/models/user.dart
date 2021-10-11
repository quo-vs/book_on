import 'package:equatable/equatable.dart';

/// User model
/// 
/// /// [User.empty] represents an unauthenticated user.
class User extends Equatable {

  const User ({
    required this.id,
    this.name,
    this.email
  });

  /// The current user's id
  final String id;

  /// The current user's email address
  final String? email;

  /// The current user's name (display name)
  final String? name;

  /// Empty user that represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to dermine whether the current user is empty
  bool get isEmpty => this == User.empty;

  @override
  List<Object?> get props => [id, email, name];

}