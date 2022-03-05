import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:vigenesia/formz/motivasi.dart';
import 'package:vigenesia/models/motivasi/motivasi_model.dart';
import 'package:vigenesia/models/motivasi_action_response/motivasi_action_response.dart';
import 'package:http/http.dart' as http;
import 'package:vigenesia/util/user_preferences.dart';

part 'form_motivasi_state.dart';

class FormMotivasiCubit extends Cubit<FormMotivasiState> {
  FormMotivasiCubit() : super(FormInitial());

  void inputChange(String value) {
    final motivasi = Motivasi.dirty(value);
    emit(
        state.copyWith(motivasi: motivasi, status: Formz.validate([motivasi])));
  }

  Future<void> submit(int userId, MotivasiModel? motivasi) async {
    final _user = await UserPreferences().loadUser();
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      var response;
      if (motivasi != null) {
        response = await http.put(
          Uri.parse('http://192.168.43.21:8000/api/motivasi/${motivasi.id}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${_user.token}',
          },
          body: jsonEncode(
            <String, String>{
              'isi': state.motivasi.value,
              'user_id': userId.toString(),
            },
          ),
        );
      } else {
        response = await http.post(
          Uri.parse('http://192.168.43.21:8000/api/motivasi'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${_user.token}',
          },
          body: jsonEncode(
            <String, String>{
              'isi': state.motivasi.value,
              'user_id': userId.toString(),
            },
          ),
        );
      }

      log(response.body);

      if (response.statusCode == 200) {
        var res = MotivasiActionResponse.fromJson(response.body);
        if (res.error == true) {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure, error: res.message));
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
