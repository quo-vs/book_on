import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/authentication/authentication_state.dart';
import '../screens/on_boarding_screen.dart';
import '../screens/page_controller_screen.dart';
import '../screens/welcome_screen.dart';
import '../utils/helper.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({ Key? key }) : super(key: key);

  @override
  _LauncherScreenState createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationBloc>().add(CheckFirstRunEvent());
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch(state.authState) {
            case AuthState.firstRun:
              Helper.pushReplacement(context, const OnBoardingScreen());
            break;
            case AuthState.authenticated:
              Helper.pushReplacement(context, const PageControllerScreen());
            break;
            case AuthState.unauthenticated: 
            Helper.pushReplacement(context, const WelcomeScreen());
          }
        },
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}