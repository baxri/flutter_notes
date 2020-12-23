import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/blocs/blocs.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: BlocConsumer<LoginBloc, LoginState>(
          listener: (_, state) {
            if (state.isSuccess) {
              Navigator.of(context).pop();
            }

            if (state.isFailure) {
              showDialog(
                  builder: (context) => AlertDialog(
                        title: Text('Error'),
                        content: Text(state.errorMessage),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'))
                        ],
                      ),
                  context: context);
            }
          },
          builder: (_, state) {
            return _buildBody(state);
          },
        ),
      ),
    );
  }

  _buildBody(LoginState state) {
    return Stack(
      children: [
        _buildForm(state),
        state.isSubmitting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  _buildForm(LoginState state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
              hintText: 'Email',
              filled: true,
              fillColor: Colors.grey[200],
              hintStyle: const TextStyle(color: Colors.black)),
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.always,
          validator: (_) =>
              !state.isEmailValid && _emailController.text.isNotEmpty
                  ? "Invalid email"
                  : null,
          onChanged: (val) {
            context.read<LoginBloc>().add(EmailChanged(email: val));
          },
        ),
        const SizedBox(
          height: 40.0,
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'Password',
              filled: true,
              fillColor: Colors.grey[200],
              hintStyle: const TextStyle(color: Colors.black)),
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          autovalidateMode: AutovalidateMode.always,
          validator: (_) =>
              !state.isPasswordValid && _passwordController.text.isNotEmpty
                  ? "Invalid password"
                  : null,
          onChanged: (val) {
            context.read<LoginBloc>().add(PasswordChanged(password: val));
          },
        ),
        const SizedBox(
          height: 50.0,
        ),
        FlatButton(
            padding: const EdgeInsets.all(12.0),
            color: Colors.black,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: state.isFormValid
                ? () {
                    context.read<LoginBloc>().add(LoginPressed(
                        email: _emailController.text,
                        password: _passwordController.text));
                  }
                : null,
            child: Text('Login')),
        SizedBox(
          height: 50.0,
        ),
        FlatButton(
            padding: const EdgeInsets.all(12.0),
            color: Colors.black,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            onPressed: state.isFormValid
                ? () {
                    context.read<LoginBloc>().add(SignupPressed(
                        email: _emailController.text,
                        password: _passwordController.text));
                  }
                : null,
            child: Text('Sign Up'))
      ],
    );
  }
}
