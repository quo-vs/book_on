import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';

import '../blocs/blocs.dart';
import '../widgets/logo.dart';
import '../widgets/sign_in_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Container(
          height: deviceSize.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const LogoImage(),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    final authBloc = BlocProvider.of<AuthBloc>(context);

                    if (state is AuthNotAuthenticated) {
                      return const SignInForm();
                    }
                    if (state is AuthFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(state.message),
                            FlatButton(
                              onPressed: () {
                                authBloc.add(AppStarted());
                              },
                              child: Text(tr('retry')),
                              textColor: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      );
                    }

                    // splash screen
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
