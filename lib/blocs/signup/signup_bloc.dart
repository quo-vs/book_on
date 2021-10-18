import '../../blocs/auth/auth.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/signup/signup_event.dart';
import '../../blocs/signup/signup_state.dart';
import '../../exceptions/auth_exception.dart';
import '../../services/auth_service.dart';

import 'package:bloc/bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthBloc _authBloc;
  final AuthService _authRepo;
  
  SignupBloc(AuthBloc? authBloc, AuthService? authRepo)
    : assert(authBloc != null),
      assert(authRepo != null),
      _authBloc = authBloc!,
      _authRepo = authRepo!,
      super(SignupInitial());


  @override
  Stream<SignupState> mapEventToState(event) async* {
    if (event is SignUpWithEmailButtonPressed) {
      yield* _mapSignupWithEmailButtonPressed(event);
    }
    if (event is SignupWithGoogleButtonPressed) {
      yield* _mapSignupWithGoogleButtonPressed(event);
    }
  }

  Stream<SignupState> _mapSignupWithEmailButtonPressed(
    SignUpWithEmailButtonPressed event) async*
  {
    yield SignupLoading();
    try {
      await _authRepo.signUp(
        email: event.email, 
        password: event.password
      );
      if (_authRepo.currentUser() != null) {
        _authBloc.add(SignedUp(displayName: _authRepo.currentUser()!.displayName ?? 'User name'));
        yield SignupSuccess();
        yield SignupInitial();
      } else {
        yield SignupFailure(message: 'Something wrong happend.');
      }
    } on AuthenticationException catch (e) {
      yield SignupFailure(message: e.message);
    } catch (err) {
      yield SignupFailure(message: err.toString());
    }
  }

    
  Stream<SignupState> _mapSignupWithGoogleButtonPressed(
    SignupWithGoogleButtonPressed event) async*
  {
    yield SignupLoading();
    try {
      await _authRepo.signInWithGoogle();
      if (_authRepo.currentUser() != null) {
        _authBloc.add(SignedUp(displayName: _authRepo.currentUser()!.displayName ?? 'User name'));
        yield SignupSuccess();
        yield SignupInitial();
      } else {
        yield SignupFailure(message: 'Something wrong happend.');
      }
    } on AuthenticationException catch (e) {
      yield SignupFailure(message: e.message);
    } catch (err) {
      yield SignupFailure(message: err.toString());
    }
  }
  
}