part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthState {}

class Anonymous extends AuthState {
  final User user;

  Anonymous(this.user);

  @override
  List<Object> get props => [user];
}

class Authtenticated extends AuthState {
  final User user;

  Authtenticated(this.user);

  @override
  List<Object> get props => [user];
}
