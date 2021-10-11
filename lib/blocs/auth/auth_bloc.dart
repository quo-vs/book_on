import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(AuthRepository authRepository)
    : assert(authRepository != null),
      _authRepository = authRepository, 
      super(AuthInitial());
  

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState(event);
    } else if(event is LoggedIn) {
      yield* _mapLoggedInToState(event);
    } else if(event is LoggedOut) {
      yield* _mapLoggedOutToState(event);
    } else if(event is SignedUp) {
      yield* _mapSignedUpToState(event);
    }
  }

  Stream<AuthState> _mapAppStartedToState(AppStarted event) async* {
    yield AuthLoading();
    try {
      final isSignedIn = _authRepository.isSignedIn();
      if (isSignedIn) {
        final user = _authRepository.currentUser();
        yield AuthAuthenticated(displayName: user!.displayName ?? '');
      }
      else {
        yield AuthNotAuthenticated();
      }
    }
    catch (e) {
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
}