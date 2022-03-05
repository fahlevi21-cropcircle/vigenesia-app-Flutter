import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:vigenesia/models/user/user.dart';

class MotivasiModel extends Equatable {
  final int? id;
  final User? user;
  final String? isi;
  final String? createdAt;

  const MotivasiModel({this.id, this.user, this.isi, this.createdAt});

  factory MotivasiModel.fromMap(Map<String, dynamic> data) => MotivasiModel(
        id: data['id'] as int?,
        user: data['user'] == null
            ? null
            : User.fromMap(data['user'] as Map<String, dynamic>),
        isi: data['isi'] as String?,
        createdAt: data['created_at'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user': user?.toMap(),
        'isi': isi,
        'created_at': createdAt,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MotivasiModel].
  factory MotivasiModel.fromJson(String data) {
    return MotivasiModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MotivasiModel] to a JSON string.
  String toJson() => json.encode(toMap());

  MotivasiModel copyWith({
    int? id,
    User? user,
    String? isi,
    String? createdAt,
  }) {
    return MotivasiModel(
      id: id ?? this.id,
      user: user ?? this.user,
      isi: isi ?? this.isi,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, user, isi, createdAt];
}
