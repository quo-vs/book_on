import 'package:book_on/exceptions/auth_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authRepository;

  AuthBloc(AuthService authRepository)
      : assert(authRepository != null),
        _authRepository = authRepository,
        super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState(event);
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState(event);
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState(event);
    } else if (event is SignedUp) {
      yield* _mapSignedUpToState(event);
    }

    if (event is LoginWithEmailButtonPressed) {
      yield* _mapLoginWithEmailButtonPressed(event);
    }
    if (event is LoginWithGoogleButtonPressed) {
      yield* _mapLoginGoogleWithEmailButtonPressed(event);
    }
    if (event is LoginAnonymouslyButtonPressed) {
      yield* _mapLoginAnonymouslyButtonPressed(event);
    }

    if (event is SignUpWithEmailButtonPressed) {
      yield* _mapSignupWithEmailButtonPressed(event);
    }
    if (event is SignupWithGoogleButtonPressed) {
      yield* _mapSignupWithGoogleButtonPressed(event);
    }
  }

  Stream<AuthState> _mapAppStartedToState(AppStarted event) async* {
    yield AuthLoading();
    try {
      final isSignedIn = _authRepository.isSignedIn();
      if (isSignedIn) {
        final user = _authRepository.currentUser();
        yield AuthAuthenticated(displayName: user!.displayName ?? '');
      } else {
        yield AuthNotAuthenticated();
      }
    } catch (e) {
      yield AuthFailure(message: e.toString());
    }
  }

  Stream<AuthState> _mapLoggedInToState(LoggedIn event) async* {
    yield AuthAuthenticated(displayName: event.displayName);
  }

  Stream<AuthState> _mapLoggedOutToState(LoggedOut event) async* {
    _authRepository.logout();
    yield AuthNotAuthenticated();
  }

  Stream<AuthState> _mapSignedUpToState(SignedUp event) async* {
    yield AuthAuthenticated(displayName: event.displayName);
  }

  Stream<AuthState> _mapLoginWithEmailButtonPressed(
      LoginWithEmailButtonPressed event) async* {
    yield AuthLoading();
    try {
      await _authRepository.login(email: event.email, password: event.password);
      if (_authRepository.currentUser() != null) {
        final user = _authRepository.currentUser();
        yield AuthAuthenticated(displayName: user!.displayName ?? '');
      } else {
        yield AuthNotAuthenticated();
      }
    } on AuthenticationException catch (e) {
      yield AuthFailure(message: e.message);
    } catch (err) {
      yield AuthFailure(message: err.toString());
    }
  }

  Stream<AuthState> _mapLoginGoogleWithEmailButtonPressed(
      LoginWithGoogleButtonPressed event) async* {
    yield AuthLoading();
    try {
      await _authRepository.logInWithGoogle();
      if (_authRepository.currentUser() != null) {
        yield AuthAuthenticated(
            displayName: _authRepository.currentUser()!.displayName ?? '');
      } else {
        yield AuthNotAuthenticated();
      }
    } on AuthenticationException catch (e) {
      yield AuthFailure(message: e.message);
    } catch (err) {
      yield AuthFailure(message: err.toString());
    }
  }

  Stream<AuthState> _mapLoginAnonymouslyButtonPressed(
      LoginAnonymouslyButtonPressed event) async* {
    yield AuthLoading();
    try {
      await _authRepository.guest();
      if (_authRepository.currentUser() != null) {
        yield AuthAuthenticated(
            displayName: _authRepository.currentUser()!.displayName ?? '');
      } else {
        yield AuthNotAuthenticated();
      }
    } on AuthenticationException catch (e) {
      yield AuthFailure(message: e.message);
    } catch (err) {
      yield AuthFailure(message: err.toString());
    }
  }

  Stream<AuthState> _mapSignupWithEmailButtonPressed(
      SignUpWithEmailButtonPressed event) async* {
    yield AuthLoading();
    try {
      await _authRepository.signUp(
          email: event.email, password: event.password);
      if (_authRepository.currentUser() != null) {
        yield AuthAuthenticated(
            displayName: _authRepository.currentUser()!.displayName ?? '');
      } else {
        yield AuthNotAuthenticated();
      }
    } on AuthenticationException catch (e) {
      yield AuthFailure(message: e.message);
    } catch (err) {
      yield AuthFailure(message: err.toString());
    }
  }

  Stream<AuthState> _mapSignupWithGoogleButtonPressed(
      SignupWithGoogleButtonPressed event) async* {
    yield AuthLoading();
    try {
      await _authRepository.signInWithGoogle();
      if (_authRepository.currentUser() != null) {
        yield AuthAuthenticated(
            displayName: _authRepository.currentUser()!.displayName ?? '');
      } else {
        yield AuthNotAuthenticated();
      }
    } on AuthenticationException catch (e) {
      yield AuthFailure(message: e.message);
    } catch (err) {
      yield AuthFailure(message: err.toString());
    }
  }
}
