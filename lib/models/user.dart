class User {
  String email;
  String firstName;
  String userID;

  User({
    this.email = '',
    this.firstName = '',
    this.userID = ''
  });

  String fullName() => firstName;

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? ''
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'id': userID,
    };
  }
}
