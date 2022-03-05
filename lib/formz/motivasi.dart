import 'package:formz/formz.dart';

enum MotivasiValidationErrors { invalid, empty, less }

class Motivasi extends FormzInput<String, MotivasiValidationErrors> {
  const Motivasi.pure() : super.pure('');
  const Motivasi.dirty([String value = '']) : super.dirty(value);

  @override
  MotivasiValidationErrors? validator(String value) {
    if (value.isEmpty) {
      return MotivasiValidationErrors.empty;
    } else if (value.length < 10) {
      return MotivasiValidationErrors.less;
    } else {
      return null;
    }
  }
}

extension ErrorMessage on MotivasiValidationErrors {
  String? get message {
    switch (this) {
      case MotivasiValidationErrors.invalid:
        return 'Motivasi tidak valid';
      case MotivasiValidationErrors.less:
        return 'Motivasi harus lebih dari 10 karakter';
      case MotivasiValidationErrors.empty:
        return 'Motivasi tidak boleh kosong';
      default:
        return null;
    }
  }
}
