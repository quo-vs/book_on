import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/welcome/welcome_bloc.dart';
import '../blocs/welcome/welcome_event.dart';
import '../blocs/welcome/welcome_state.dart';
import '../screens/auth/login_screen.dart';
import '../screens/page_controller_screen.dart';
import '../screens/sign_up_screen.dart';
import '../utils/helper.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WelcomeBloc>(
      create: (ctx) => WelcomeBloc(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocListener<WelcomeBloc, WelcomeState>(
              listener: (context, state) {
                if (state is WelcomeInitial) {}
                switch ((state as WelcomeInitial).pressTarget) {
                  case WelcomePressTarget.login:
                    Helper.push(context, const LoginScreen());
                    break;
                  case WelcomePressTarget.signup:
                    Helper.push(context, const SignUpScreen());
                    break;
                  case WelcomePressTarget.guest:
                    Helper.push(context, const PageControllerScreen());
                    break;
                  default:
                    break;
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/logo_new.png',
                      width: 150.0,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 32, bottom: 8),
                    child: Text(
                      tr('bookOn'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 40, left: 40, top: 40),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      child: Text(
                        tr('login'),
                        style: const TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        context.read<WelcomeBloc>().add(LoginPressed());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 40, left: 40, top: 20, bottom: 20),
                    child: TextButton(
                        child: Text(
                          tr('signup'),
                          style: const TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          context.read<WelcomeBloc>().add(SignupPressed());
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.only(top: 12, bottom: 12),
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text(tr('or'))),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 40, left: 40, bottom: 20),
                    child: TextButton(
                      child: Text(
                        tr('exploreAnonymously'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                      onPressed: () {
                        context.read<WelcomeBloc>().add(ExporeAsGuestPressed());
                        context.read<AuthenticationBloc>().add(LoginAsGuest());
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
