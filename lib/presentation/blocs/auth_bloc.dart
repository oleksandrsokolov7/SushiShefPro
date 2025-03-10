import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pidkazki2/core/services/authentication_service.dart';

abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignOutRequested extends AuthEvent {}

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<AuthCheckRequested>(_checkAuthStatus);
    on<SignInRequested>(_signIn);
    on<SignOutRequested>(_signOut);
  }

  Future<void> _checkAuthStatus(
      AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final user = await _authService.authStateChanges.first;
    if (user != null) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _signIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.signIn(event.email, event.password);
      emit(Authenticated());
    } catch (e) {
      emit(Unauthenticated());
    }
  }

  Future<void> _signOut(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _authService.signOut();
    emit(Unauthenticated());
  }
}
