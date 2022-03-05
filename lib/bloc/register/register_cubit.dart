import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vigenesia/formz/email.dart';
import 'package:vigenesia/formz/name.dart';
import 'package:vigenesia/formz/password.dart';
import 'package:http/http.dart' as http;
import 'package:vigenesia/models/auth_response/auth_response.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(const RegisterState());

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(
        name: name,
        status: Formz.validate([name, state.email, state.password])));
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
        email: email,
        status: Formz.validate([email, state.name, state.password])));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
        password: password,
        status: Formz.validate([password, state.name, state.email])));
  }

  Future<void> register() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var response = await http.post(
        Uri.parse('http://192.168.43.21:8000/api/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(
          <String, String>{
            'name': state.name.value,
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
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        }
      }
    } catch (e) {
      emit(state.copyWith(
          status: FormzStatus.submissionFailure, error: e.toString()));
    }
  }
}
