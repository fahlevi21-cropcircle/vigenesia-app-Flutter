import 'dart:convert';

class User {
  int? id;
  String? name;
  String? email;
  String? role;
  String? createdAt;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.role,
    this.createdAt,
    this.token,
  });

  factory User.fromMap(Map<String, dynamic> data) => User(
        id: data['id'] as int?,
        name: data['name'] as String?,
        email: data['email'] as String?,
        role: data['role'] as String?,
        createdAt: data['created_at'] as String?,
        token: data['token'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'created_at': createdAt,
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());
}
