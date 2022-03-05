part of 'form_motivasi_cubit.dart';

class FormMotivasiState extends Equatable {
  const FormMotivasiState({
    this.motivasi = const Motivasi.pure(),
    this.status = FormzStatus.pure,
    this.error = "",
  });

  final Motivasi motivasi;
  final FormzStatus status;
  final String error;

  @override
  List<Object> get props => [motivasi, status, error];

  FormMotivasiState copyWith(
      {Motivasi? motivasi, FormzStatus? status, String? error}) {
    return FormMotivasiState(
        motivasi: motivasi ?? this.motivasi,
        status: status ?? this.status,
        error: error ?? this.error);
  }
}

class FormInitial extends FormMotivasiState {}
