import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:vigenesia/bloc/login/login_cubit.dart';

import 'package:vigenesia/formz/email.dart';
import 'package:vigenesia/formz/password.dart';
import 'package:vigenesia/util/user_preferences.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(),
      child: const LoginForm(),
    ));
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var isValid = false;

  @override
  void initState() {
    UserPreferences().loadUser().then(
      (value) {
        if (value.id != null) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/home', (route) => false);
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocConsumer<LoginCubit, LoginState>(builder: (ctx, state) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height,
            width: size.width,
            child: Column(
              children: [
                _buildHeader(size),
                _buildBody(size),
                Text(
                  'Universitas Bina Sarana Informatika',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                ),
                Text(
                  '2021',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ),
        ),
      );
    }, listener: (ctx, state) {
      if (state.status.isSubmissionSuccess) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Success")));
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }

      if (state.status.isValid) {
        isValid = true;
      }
      print(state.status);
    });
  }

  Widget _buildHeader(Size size) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          child: SvgPicture.asset(
            'images/wave_head.svg',
            height: size.height * 0.28,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Image.asset(
            'images/logo.png',
            fit: BoxFit.contain,
            width: 120,
            height: 120,
          ),
        )
      ],
    );
  }

  Widget _buildBody(Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.58,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Selamat Datang!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 24.0,
          ),
          _buildEmailInput(),
          SizedBox(
            height: 16.0,
          ),
          _buildPasswordInput(),
          SizedBox(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  // Respond to button press
                  Navigator.pushNamed(context, '/register');
                },
                child: Text("DAFTAR"),
              ),
              SizedBox(
                width: 8.0,
              ),
              ElevatedButton(
                onPressed: isValid
                    ? () {
                        // Respond to button press
                        context.read<LoginCubit>().login();
                      }
                    : null,
                child: Text('MASUK'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailInput() {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (prev, current) =>
          prev.email != current.email ||
          current.exceptionError.contains("user"),
      builder: (ctx, state) {
        return TextFormField(
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
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
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (prev, current) =>
          prev.password != current.password ||
          current.exceptionError.contains("password"),
      builder: (ctx, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<LoginCubit>().passwordChanged(value),
          decoration: InputDecoration(
            errorText: state.exceptionError.contains("password")
                ? state.exceptionError
                : state.password.error?.name,
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        );
      },
    );
  }
}
