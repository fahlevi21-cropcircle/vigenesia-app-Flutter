import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:vigenesia/bloc/register/register_cubit.dart';

import 'package:vigenesia/formz/email.dart';
import 'package:vigenesia/formz/name.dart';
import 'package:vigenesia/formz/password.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<RegisterCubit>(
      create: (_) => RegisterCubit(),
      child: const RegisterForm(),
    ));
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var isValid = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<RegisterCubit, RegisterState>(builder: (ctx, state) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 32, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildBody(size),
                    Text(
                      'Universitas Bina Sarana Informatika',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                    ),
                    Text(
                      '2021',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
                    ),
                  ],
                )),
          ),
        ),
      );
    }, listener: (ctx, state) {
      if (state.status.isSubmissionSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Register Success")));
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }

      if (state.status.isValid) {
        isValid = true;
      }

      if (state.status.isInvalid) {
        isValid = false;
      }

      if (state.status.isSubmissionInProgress) {
        isValid = false;
      }
    });
  }

  Widget _buildBody(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.80,
      child: Column(
        children: [
          Text(
            "Form Pendaftaran",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 24.0,
          ),
          _buildNameInput(),
          SizedBox(
            height: 16.0,
          ),
          _buildEmailInput(),
          SizedBox(
            height: 16.0,
          ),
          _buildPasswordInput(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Respond to button press
                  Navigator.pop(context);
                },
                child: Text("KEMBALI"),
              ),
              SizedBox(
                width: 8.0,
              ),
              ElevatedButton(
                onPressed: isValid
                    ? () {
                        // Respond to button press
                        context.read<RegisterCubit>().register();
                      }
                    : null,
                child: Text('DAFTAR'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (prev, current) => prev.name != current.name,
      builder: (ctx, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<RegisterCubit>().nameChanged(value),
          decoration: InputDecoration(
            errorText: state.name.error?.name,
            labelText: 'Nama Lengkap',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildEmailInput() {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (prev, current) => prev.email != current.email,
      builder: (ctx, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<RegisterCubit>().emailChanged(value),
          decoration: InputDecoration(
            errorText: state.email.error?.name,
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildPasswordInput() {
    return BlocBuilder<RegisterCubit, RegisterState>(
      buildWhen: (prev, current) => prev.password != current.password,
      builder: (ctx, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<RegisterCubit>().passwordChanged(value),
          decoration: InputDecoration(
            errorText: state.password.error?.name,
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        );
      },
    );
  }
}
