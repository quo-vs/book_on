import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../blocs.dart';
import '../../exceptions/auth_exception.dart';
import '../../repositories/auth_repository.dart';


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc _authBloc;
  final AuthRepository _authRepo;
  
  LoginBloc(AuthBloc? authBloc, AuthRepository? authRepo)
    : assert(authBloc != null),
      assert(authRepo != null),
      _authBloc = authBloc!,
      _authRepo = authRepo!,
      super(LoginInitial());


  @override
  Stream<LoginState> mapEventToState(event) async* {
    if (event is LoginWithEmailButtonPressed) {
      yield* _mapLoginWithEmailButtonPressed(event);
    }
    if (event is LoginWithGoogleButtonPressed) {
      yield* _mapLoginGoogleWithEmailButtonPressed(event);
    }
    if (event is LoginAnonymouslyButtonPressed) {
      yield* _mapLoginAnonymouslyButtonPressed(event);
    }
  }

  Stream<LoginState> _mapLoginWithEmailButtonPressed(
    LoginWithEmailButtonPressed event) async*
  {
    yield LoginLoading();
    try {
      await _authRepo.login(
        email: event.email, 
        password: event.password
      );
      if (_authRepo.currentUser() != null) {
        _authBloc.add(LoggedIn(displayName: _authRepo.currentUser()!.displayName ?? 'User name'));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(message: tr('internalErrorOccured'));
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(message: e.message);
    } catch (err) {
      yield LoginFailure(message: err.toString());
    }
  }
  
   Stream<LoginState> _mapLoginGoogleWithEmailButtonPressed(
    LoginWithGoogleButtonPressed event) async*
  {
    yield LoginLoading();
    try {
      await _authRepo.logInWithGoogle();
      if (_authRepo.currentUser() != null) {
        _authBloc.add(LoggedIn(displayName: _authRepo.currentUser()!.displayName ?? ''));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(message: tr('internalErrorOccured'));
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(message: e.message);
    } catch (err) {
      yield LoginFailure(message: err.toString());
    }
  }

  Stream<LoginState> _mapLoginAnonymouslyButtonPressed(
    LoginAnonymouslyButtonPressed event) async*
  {
    yield LoginLoading();
    try {
      await _authRepo.guest();
      if (_authRepo.currentUser() != null) {
        _authBloc.add(LoggedIn(displayName: _authRepo.currentUser()!.displayName ?? 'Anonym'));
        yield LoginSuccess();
        yield LoginInitial();
      } else {
        yield LoginFailure(message: 'Something wrong happend.');
      }
    } on AuthenticationException catch (e) {
      yield LoginFailure(message: e.message);
    } catch (err) {
      yield LoginFailure(message: err.toString());
    }
  }

}