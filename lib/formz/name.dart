import 'package:formz/formz.dart';

enum NameValidationErrors { invalid, less, empty }

class Name extends FormzInput<String, NameValidationErrors> {
  const Name.pure() : super.pure('');
  const Name.dirty([String value = '']) : super.dirty(value);

  @override
  NameValidationErrors? validator(String value) {
    if (value.isEmpty) {
      return NameValidationErrors.empty;
    } else if (value.length < 4) {
      return NameValidationErrors.less;
    } else {
      return null;
    }
  }
}

extension ErrorMessage on NameValidationErrors {
  String? get name {
    switch (this) {
      case NameValidationErrors.invalid:
        return 'Nama tidak valid';
      case NameValidationErrors.less:
        return 'Nama tidak boleh kurang dari 4 karakter';
      case NameValidationErrors.empty:
        return 'Nama tidak boleh kosong';
      default:
        return null;
    }
  }
}
