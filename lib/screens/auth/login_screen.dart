import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';
import '../../blocs/authentication/authentication_event.dart';
import '../../blocs/authentication/authentication_state.dart';
import '../../blocs/loading/loading_cubit.dart';
import '../../blocs/login/login_bloc.dart';
import '../../blocs/login/login_event.dart';
import '../../blocs/login/login_state.dart';
import '../../screens/page_controller_screen.dart';
import '../../screens/reset_password_screen.dart';
import '../../utils/alerts_helper.dart';
import '../../utils/helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (ctx) => LoginBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
                color:
                    Helper.isDarkMode(context) ? Colors.white : Colors.black),
            elevation: 0.0,
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<AuthenticationBloc, AuthenticationState>(
                listener: (context, state) {
                  context.read<LoadingCubit>().hideLoading();
                  if (state.authState == AuthState.authenticated) {
                    Helper.pushAndRemoveUntil(
                        context, PageControllerScreen(), false);
                  } else {
                    AlertHelper.showSnackBar(context,
                        state.message ?? tr('couldNotLogin'));
                  }
                },
              ),
              BlocListener<LoginBloc, LoginState>(listener: (context, state) {
                if (state is ValidLoginFields) {
                  context.read<LoadingCubit>().showLoading(
                      context, tr('loading'), false);
                  context.read<AuthenticationBloc>().add(
                        LoginWithEmailAndPasswordEvent(
                            email: email!, password: password!),
                      );
                }
              })
            ],
            child: BlocBuilder<LoginBloc, LoginState>(
              buildWhen: (old, current) =>
                  current is LoginFailureState && old != current,
              builder: (context, state) {
                if (state is LoginFailureState) {
                  _validate = AutovalidateMode.onUserInteraction;
                }
                return Form(
                  key: _key,
                  autovalidateMode: _validate,
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 32, right: 16, left: 16),
                        child: Text(
                          tr('signIn'),
                          style: const TextStyle(fontSize: 25.0),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 32, right: 24, left: 24),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          textInputAction: TextInputAction.next,
                          validator: Helper.validateEmail,
                          onSaved: (String? val) {
                            email = val;
                          },
                          style: const TextStyle(fontSize: 18),
                          keyboardType: TextInputType.emailAddress,
                          decoration: Helper.getInputDecoration(
                            hint: tr('email_label'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 32.0, right: 24.0, left: 24.0),
                        child: TextFormField(
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: true,
                          validator: Helper.validatePassword,
                          onSaved: (String? val) {
                            password = val;
                          },
                          onFieldSubmitted: (password) => context
                              .read<LoginBloc>()
                              .add(ValidateLoginFieldsEvent(_key)),
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(fontSize: 18.0),
                          decoration: Helper.getInputDecoration(
                            hint: tr('password_label'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16, right: 24),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Helper.push(context, const ReetPasswordScreen());
                            },
                            child: Text(
                              tr('forgotPassword'),
                              style: const TextStyle(
                                  fontSize: 15, letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 40, left: 40, top: 40),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              )),
                          child: Text(
                            tr('login'),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            context
                                .read<LoginBloc>()
                                .add(ValidateLoginFieldsEvent(_key));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
