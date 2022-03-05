import 'package:formz/formz.dart';

enum PasswordValidationError { invalid, empty, less }

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(r'^[A-Za-z\d@$!%*?&]{8,}$');

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    } else if (value.length < 8) {
      return PasswordValidationError.less;
    } else if (!_passwordRegExp.hasMatch(value)) {
      return PasswordValidationError.invalid;
    } else {
      return null;
    }
  }
}

extension ErrorMessage on PasswordValidationError {
  String? get name {
    switch (this) {
      case PasswordValidationError.invalid:
        return 'Password tidak valid';
      case PasswordValidationError.empty:
        return 'Password harus diisi';
      case PasswordValidationError.less:
        return 'Password harus 8 karakter';
      default:
        return null;
    }
  }
}
