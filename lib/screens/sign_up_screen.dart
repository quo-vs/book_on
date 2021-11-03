import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../blocs/authentication/authentication_event.dart';
import '../blocs/authentication/authentication_state.dart';
import '../blocs/loading/loading_cubit.dart';
import '../blocs/signUp/sign_up_bloc.dart';
import '../blocs/signUp/sign_up_event.dart';
import '../blocs/signUp/sign_up_state.dart';
import '../screens/page_controller_screen.dart';
import '../utils/alerts_helper.dart';
import '../utils/helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey();
  String? name, email, password, confirmPassword;
  AutovalidateMode _validate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpBloc>(
      create: (context) => SignUpBloc(),
      child: Builder(
        builder: (context) {
          return MultiBlocListener(
            listeners: [
              BlocListener<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                context.read<LoadingCubit>().hideLoading();
                if (state.authState == AuthState.authenticated) {
                  Helper.pushAndRemoveUntil(
                      context, const PageControllerScreen(), false);
                } else {
                  AlertHelper.showSnackBar(
                      context, state.message ?? tr('couldNotSignUp'));
                }
              }),
              BlocListener<SignUpBloc, SignUpState>(
                listener: (context, state) {
                  if (state is ValidFields) {
                    context.read<LoadingCubit>().showLoading(
                        context, tr('creatingAccountLoading'), false);
                    context.read<AuthenticationBloc>().add(
                        SignupWithEmailAndPasswordEvent(
                            email: email!, password: password!, name: name));
                  } else if (state is SignUpFailreState) {
                    AlertHelper.showSnackBar(context, state.message);
                  }
                },
              )
            ],
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(
                  color:
                      Helper.isDarkMode(context) ? Colors.white : Colors.black,
                ),
              ),
              body: SingleChildScrollView(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
                child: BlocBuilder<SignUpBloc, SignUpState>(
                  buildWhen: (old, current) =>
                      current is SignUpFailreState && old != current,
                  builder: (context, state) {
                    if (state is SignUpFailreState) {
                      _validate = AutovalidateMode.onUserInteraction;
                    }
                    return Form(
                      key: _key,
                      autovalidateMode: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            tr(
                              'createNewAccount',
                            ),
                            style: const TextStyle(fontSize: 25.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 16, right: 8),
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              onSaved: (val) {
                                name = val;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: Helper.getInputDecoration(
                                hint: tr('name'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 8, right: 8),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              validator: Helper.validateEmail,
                              onSaved: (val) => email = val!,
                              style: const TextStyle(fontSize: 18.0),
                              keyboardType: TextInputType.emailAddress,
                              decoration: Helper.getInputDecoration(
                                hint: tr('email_label'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 8, right: 8),
                            child: TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              controller: _passwordController,
                              validator: Helper.validatePassword,
                              onSaved: (val) {
                                password = val!;
                              },
                              style: const TextStyle(fontSize: 18),
                              decoration: Helper.getInputDecoration(
                                  hint: tr('password_label')),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 8, right: 8),
                            child: TextFormField(
                              obscureText: true,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) =>
                                context.read<SignUpBloc>().add(
                                  ValidateFieldsEvent(_key),
                              ),
                              validator: (val) =>
                                  Helper.validateConfirmPassword(
                                      _passwordController.text, val),
                              onSaved: (val) {
                                confirmPassword = val!;
                              },
                              style: const TextStyle(fontSize: 18),
                              decoration: Helper.getInputDecoration(
                                  hint: tr('confirm_password_label')),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 40.0, left: 40.0, top: 40.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                  side: const BorderSide(
                                  ),
                                ),
                              ),
                              child: Text(
                                tr('signup'),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () => context.read<SignUpBloc>().add(ValidateFieldsEvent(_key),),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}
