import 'dart:convert';

import 'package:vigenesia/models/motivasi/motivasi_model.dart';

class MotivasiResponse {
  List<MotivasiModel>? data;

  MotivasiResponse({this.data});

  factory MotivasiResponse.fromMap(Map<String, dynamic> data) {
    return MotivasiResponse(
      data: (data['data'] as List<dynamic>?)
          ?.map((e) => MotivasiModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'data': data?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MotivasiResponse].
  factory MotivasiResponse.fromJson(String data) {
    return MotivasiResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MotivasiResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
