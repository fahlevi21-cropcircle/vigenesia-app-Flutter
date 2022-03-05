import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vigenesia/bloc/form/form_motivasi_cubit.dart';

import 'package:vigenesia/formz/motivasi.dart';
import 'package:vigenesia/models/motivasi/motivasi_model.dart';
import 'package:vigenesia/models/user/user.dart';
import 'package:vigenesia/util/user_preferences.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    final MotivasiModel? motivasi =
        ModalRoute.of(context)!.settings.arguments as MotivasiModel?;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => {Navigator.of(context).pop()},
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff07E4F8),
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          motivasi == null ? 'Buat Motivasi' : 'Update Motivasi',
          style: TextStyle(
            color: Color(0xff07E4F8),
          ),
        ),
      ),
      body: BlocProvider<FormMotivasiCubit>(
        create: (_) => FormMotivasiCubit(),
        child: InputForm(motivasi: motivasi),
      ),
    );
  }
}

class InputForm extends StatefulWidget {
  final MotivasiModel? motivasi;
  const InputForm({Key? key, this.motivasi}) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var isValid = false;
  var user = User();

  @override
  void initState() {
    super.initState();
    UserPreferences().loadUser().then(
      (value) {
        if (value.id != null) {
          user = value;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FormMotivasiCubit, FormMotivasiState>(
      builder: (_, state) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              motivasiForm(),
              SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: isValid
                    ? () {
                        // Respond to button press
                        if (widget.motivasi != null) {
                          context
                              .read<FormMotivasiCubit>()
                              .submit(user.id!, widget.motivasi);
                        } else {
                          context
                              .read<FormMotivasiCubit>()
                              .submit(user.id!, null);
                        }
                      }
                    : null,
                child: Text(widget.motivasi == null ? 'Selesai' : 'Update'),
              ),
            ],
          ),
        );
      },
      listener: (_, state) {
        if (state.status == FormzStatus.submissionInProgress) {
          isValid = false;
        } else if (state.status == FormzStatus.submissionFailure) {
          isValid = false;
        } else {
          isValid = true;
        }

        if (state.status.isSubmissionSuccess) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Success'),
            ),
          );
        }
      },
    );
  }

  Widget motivasiForm() {
    if (widget.motivasi != null) isValid = true;
    return BlocBuilder<FormMotivasiCubit, FormMotivasiState>(
      buildWhen: (previous, current) =>
          previous.motivasi.value != current.motivasi.value,
      builder: (ctx, state) {
        return TextFormField(
          maxLines: null,
          keyboardType: TextInputType.multiline,
          onChanged: (value) =>
              context.read<FormMotivasiCubit>().inputChange(value),
          decoration: InputDecoration(
            errorText:
                widget.motivasi != null ? null : state.motivasi.error?.message,
            labelText: 'Isi motivasi',
            border: OutlineInputBorder(),
          ),
          initialValue: widget.motivasi != null && widget.motivasi!.isi != null
              ? widget.motivasi!.isi
              : null,
        );
      },
    );
  }
}
