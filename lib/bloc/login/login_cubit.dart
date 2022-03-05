import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vigenesia/formz/email.dart';
import 'package:vigenesia/formz/password.dart';
import 'package:http/http.dart' as http;
import 'package:vigenesia/models/auth_response/auth_response.dart';

import 'package:equatable/equatable.dart';
import 'package:vigenesia/util/user_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
        email: email, status: Formz.validate([email, state.password])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
        password: password, status: Formz.validate([password, state.email])));
  }

  Future<void> login() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var response = await http.post(
        Uri.parse('http://192.168.43.21:8000/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(
          <String, String>{
            'email': state.email.value,
            'password': state.password.value,
          },
        ),
      );

      log(response.body);

      if (response.statusCode == 200) {
        var auth = AuthResponse.fromJson(response.body);
        if (auth.error == true) {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure, error: auth.message));
        } else {
          final myprefs = new UserPreferences();
          myprefs.saveUser(auth.user!);
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, error: e.toString()));
    }
  }
}
