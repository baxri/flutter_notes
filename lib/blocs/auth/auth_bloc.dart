import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_notes/models/models.dart';
import 'package:flutter_notes/repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(AuthRepository authRepository)
      : _authRepository = authRepository,
        super(Unauthenticated());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is Login) {
      yield* _mapLoginToState();
    } else if (event is LogOut) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      User currentUser = await _authRepository.getCurrentUser();

      if (currentUser == null) {
        currentUser = await _authRepository.loginAnonymously();
      }

      final isAnonymous = _authRepository.isAnonymous();

      if (isAnonymous) {
        yield Anonymous(currentUser);
      } else {
        yield Authtenticated(currentUser);
      }
    } catch (err) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoginToState() async* {
    try {
      User currentUser = await _authRepository.getCurrentUser();
      yield Authtenticated(currentUser);
    } catch (err) {
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLogoutToState() async* {
    try {
      await _authRepository.logout();
      yield* _mapAppStartedToState();
    } catch (err) {
      yield Unauthenticated();
    }
  }
}
