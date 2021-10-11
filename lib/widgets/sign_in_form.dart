import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/login/login_bloc.dart';
import '../blocs/login/login_event.dart';
import '../blocs/signup/signup_bloc.dart';
import '../blocs/signup/signup_event.dart';
import '../widgets/auth_buttom_row.dart';
import '../utils/constants.dart';
import '../utils/alerts_helper.dart';


class SignInForm extends StatefulWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _autoValidate = false;

  final Connectivity _connectivity = Connectivity();

  var _isLogin = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _loginBloc = BlocProvider.of<LoginBloc>(context);
    final _signUpBloc = BlocProvider.of<SignupBloc>(context);

    Future<bool> isOffline() async {
      var result = await _connectivity.checkConnectivity();
      return Future.value(result.index == ConnectivityResult.none.index);
    }

    _onLoginButtonPressed() async {
      if (await isOffline()) {
        AlertHelper.showOfflineAlert(context);
        return;
      }
      if (_key.currentState!.validate()) {
        _loginBloc.add(LoginWithEmailButtonPressed(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = false;
        });
      }
    }

    _onSignUpButtonPressed() async {
      if (await isOffline()) {
        AlertHelper.showOfflineAlert(context);
        return;
      }
      if (_key.currentState!.validate()) {
        _signUpBloc.add(SignUpWithEmailButtonPressed(
            email: _emailController.text, password: _passwordController.text));
      } else {
        setState(() {
          _autoValidate = false;
        });
      }
    }

    _onAnonymousButtonPressed() async {
      if (await isOffline()) {
        AlertHelper.showOfflineAlert(context);
        return;
      }
      _loginBloc.add(LoginAnonymouslyButtonPressed());
    }

    void _switchAuthMode() {
      setState(() {
        _isLogin = !_isLogin;
      });
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height -
          AppConst.imageLogoHeight -
          AppConst.heightBetweenWidgets * 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GoogleLoginButton(isOffline),
          Row(children: <Widget>[
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: const Divider(
                    color: Colors.black,
                    height: 50,
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                tr("or"),
                style: const TextStyle(fontSize: 28),
              ),
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: const Divider(
                    color: Colors.black,
                    height: 50,
                  )),
            ),
          ]),
          Form(
            key: _key,
            autovalidateMode: _autoValidate == true
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      labelText: tr('email_label'),
                      fillColor: Colors.transparent,
                      filled: true,
                      isDense: true,
                      prefixIcon: const Icon(Icons.email)),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: (value) {
                    if (value == null) {
                      return tr('email_required_error');
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: AppConst.heightBetweenWidgets,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: tr('password_label'),
                      fillColor: Colors.transparent,
                      filled: true,
                      isDense: true,
                      prefixIcon: const Icon(Icons.password)),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null) {
                      return tr('password_required_error');
                    }
                    return null;
                  },
                ),
                if (!_isLogin)
                  const SizedBox(
                    height: AppConst.heightBetweenWidgets,
                  ),
                if (!_isLogin)
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: tr('confirm_password_label'),
                        fillColor: Colors.transparent,
                        filled: true,
                        isDense: true,
                        prefixIcon: const Icon(Icons.password)),
                    obscureText: true,
                    controller: _confirmController,
                    validator: (value) {
                      if (value == null || _passwordController.text != value) {
                        return tr('confirm_password_error');
                      }
                      return null;
                    },
                  ),
                const SizedBox(
                  height: AppConst.heightBetweenWidgets,
                ),
                RaisedButton(
                    color: Theme.of(context).accentColor,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(_isLogin ? tr('login') : tr('signup')),
                    onPressed: _isLogin
                        ? _onLoginButtonPressed
                        : _onSignUpButtonPressed),
                const SizedBox(
                  height: AppConst.heightBetweenWidgets,
                ),
                AuthButtonsRow(
                  isLogin: _isLogin,
                  switchAuthMode: _switchAuthMode,
                )
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: _onAnonymousButtonPressed,
                child: Text(tr('exploreAnonymously'),
                    style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showError(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(errorMessage),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}

class _GoogleLoginButton extends StatelessWidget {
  final Function isOfflineHandler;

  _GoogleLoginButton(this.isOfflineHandler);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.icon(
        key: const Key('googleLogin_elevatedButton'),
        label: Text(
          tr('signInWithGoogle'),
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: theme.colorScheme.secondary,
        ),
        icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
        onPressed: () async {
          if (await isOfflineHandler()) {
            AlertHelper.showOfflineAlert(context);
            return;
          }

          BlocProvider.of<SignupBloc>(context)
              .add(SignupWithGoogleButtonPressed());
        });
  }
}
