import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'motivasi_model.dart';

class MotivasiResponse extends Equatable {
  final MotivasiModel? data;

  const MotivasiResponse({this.data});

  factory MotivasiResponse.fromMap(Map<String, dynamic> data) =>
      MotivasiResponse(
        data: data['data'] == null
            ? null
            : MotivasiModel.fromMap(data['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'data': data?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MotivasiResponse].
  factory MotivasiResponse.fromJson(String data) {
    return MotivasiResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MotivasiModel] to a JSON string.
  String toJson() => json.encode(toMap());

  MotivasiResponse copyWith({
    MotivasiModel? data,
  }) {
    return MotivasiResponse(
      data: data ?? this.data,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [data];
}
