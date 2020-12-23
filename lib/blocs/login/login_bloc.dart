import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repositories/repositories.dart';
import '../../blocs/blocs.dart';

part 'login_event.dart';
part 'login_state.dart';

class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return password.length > 5;
  }
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  AuthBloc _authBloc;
  AuthRepository _authRepository;

  LoginBloc({
    @required AuthBloc authBloc,
    @required AuthRepository authRepository,
  })  : _authBloc = authBloc,
        _authRepository = authRepository,
        super(LoginState.empty());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event);
    } else if (event is LoginPressed) {
      yield* _mapLoginPressedToState(event);
    } else if (event is SignupPressed) {
      yield* _mapSignupPressedToState(event);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(EmailChanged event) async* {
    yield state.update(isEmailValid: Validators.isValidEmail(event.email));
  }

  Stream<LoginState> _mapPasswordChangedToState(PasswordChanged event) async* {
    yield state.update(
        isPasswordValid: Validators.isValidPassword(event.password));
  }

  Stream<LoginState> _mapLoginPressedToState(LoginPressed event) async* {
    yield LoginState.loading();
    try {
      await _authRepository.loginWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      _authBloc.add(Login());
      yield LoginState.success();
    } catch (err) {
      yield LoginState.failure(err.message);
    }
  }

  Stream<LoginState> _mapSignupPressedToState(SignupPressed event) async* {
    yield LoginState.loading();
    try {
      await _authRepository.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      _authBloc.add(Login());
      yield LoginState.success();
    } catch (err) {
      yield LoginState.failure(err.message);
    }
  }
}
