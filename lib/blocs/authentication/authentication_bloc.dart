import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/authentication/authentication_state.dart';
import '../../main.dart';
import '../../models/user.dart';
import '../../services/authentication_service.dart';

class AuthenticationBloc 
  extends Bloc<AuthenticationEvent, AuthenticationState> {
  
  User? user;
  late bool finishedOnBoarding;

  AuthenticationBloc({this.user}) 
    : super(AuthenticationState.unauthenticated()) 
  {
    on<CheckFirstRunEvent>((event, emit) async {
      finishedOnBoarding = sharedPrefs.getOnBoardingFinished();
      if (!finishedOnBoarding) {
        emit(const AuthenticationState.onboarding());
      } else {
        user = await AuthenticationService.getAuthUser();
        if (user == null) {
          emit(AuthenticationState.unauthenticated());
        }
        else {
          emit(AuthenticationState.authenticated(user!));
        }
      }
    });

    on<FinishedOnBoardingEvent>((event, emit) async {
      await sharedPrefs.setOnBoardingFinished(true);
      emit(AuthenticationState.unauthenticated());
    });

    on<LoginWithEmailAndPasswordEvent>((event, emit) async {
      dynamic result = await AuthenticationService.loginWithEmailAndPassword(
        event.email, event.password);
      if (result != null && result is User) {
        emit(AuthenticationState.authenticated(result));
      } else if (result != null && result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      } else {
        emit(AuthenticationState.unauthenticated(
          message: tr('loginFailed')
        ));
      }
    });

    on<LoginAsGuest>((event, emit) async{
      dynamic result = await AuthenticationService.signInAsGuest();
      if (result != null) {
        emit(AuthenticationState.authenticated(result));
      } else {
        emit(AuthenticationState.unauthenticated(
          message: tr('loginFailed')
        ));
      }
    });

    on<SignupWithEmailAndPasswordEvent>((event, emit) async {
      dynamic result = await AuthenticationService.signUpWithEmailAndPassword(
        email: event.email, 
        password: event.password,
        name: event.name
      );      
      if (result != null && result is User) {
        user = result;
        emit(AuthenticationState.authenticated(user!));
      } else if (result != null && result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      } else {
        emit(AuthenticationState.unauthenticated(message: tr('couldNotSignUp')));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await AuthenticationService.logout();
      user = null;
      emit(AuthenticationState.unauthenticated());
    });
  }
  
}