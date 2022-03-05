import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:vigenesia/models/motivasi/motivasi_model.dart';

class MotivasiActionResponse extends Equatable {
  final String? message;
  final int? code;
  final bool? error;
  final MotivasiModel? data;

  const MotivasiActionResponse({
    this.message,
    this.code,
    this.error,
    this.data,
  });

  factory MotivasiActionResponse.fromMap(Map<String, dynamic> data) {
    return MotivasiActionResponse(
      message: data['message'] as String?,
      code: data['code'] as int?,
      error: data['error'] as bool?,
      data: data['data'] == null
          ? null
          : MotivasiModel.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'message': message,
        'code': code,
        'error': error,
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MotivasiActionResponse].
  factory MotivasiActionResponse.fromJson(String data) {
    return MotivasiActionResponse.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MotivasiActionResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [message, code, error, data];
}
