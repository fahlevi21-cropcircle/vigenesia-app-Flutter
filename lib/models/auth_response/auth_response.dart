import 'dart:convert';

import '../user/user.dart';

class AuthResponse {
  String? message;
  int? code;
  bool? error;
  User? user;

  AuthResponse({this.message, this.code, this.error, this.user});

  factory AuthResponse.fromMap(Map<String, dynamic> data) => AuthResponse(
        message: data['message'] as String?,
        code: data['code'] as int?,
        error: data['error'] as bool?,
        user: data['data'] == null
            ? null
            : User.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'code': code,
        'error': error,
        'data': user?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [AuthResponse].
  factory AuthResponse.fromJson(String data) {
    return AuthResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [AuthResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
