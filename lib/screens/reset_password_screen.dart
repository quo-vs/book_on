import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easy_localization/easy_localization.dart';

import '../blocs/loading/loading_cubit.dart';
import '../blocs/resetPassword/reset_password_cubit.dart';
import '../blocs/resetPassword/reset_password_state.dart';
import '../utils/alerts_helper.dart';
import '../utils/helper.dart';

class ReetPasswordScreen extends StatefulWidget {
  const ReetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ReetPasswordScreen> createState() => _ReetPasswordScreenState();
}

class _ReetPasswordScreenState extends State<ReetPasswordScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  AutovalidateMode _validate = AutovalidateMode.disabled;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ResetPasswordCubit>(
      create: (context) => ResetPasswordCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
               iconTheme: IconThemeData(
              color: Helper.isDarkMode(context) ? Colors.white : Colors.black),
            ),
            body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
              listenWhen: (old, current) => old != current,
              listener: (context, state) {
                if (state is ResetPasswordDone) {
                  context.read<LoadingCubit>().hideLoading();
                  AlertHelper.showSnackBar(context, tr('resetPasswordSent'));
                  Navigator.pop(context);
                } else if (state is ValidResetPasswordFiels) {
                  context
                    .read<LoadingCubit>()
                    .showLoading(context, 'Sending email...', false);
                  context 
                    .read<ResetPasswordCubit>()
                    .resetPassword(_email);
                } else if (state is ResetPasswordFailureState) {
                  AlertHelper.showSnackBar(context, state.message);
                }
              },
              buildWhen: (old, current) => current is ResetPasswordFailureState && old != current,
              builder: (context, state) {
                if (state is ResetPasswordFailureState) {
                  _validate = AutovalidateMode.onUserInteraction;
                }
                return Form(
                  key: _key,
                  autovalidateMode: _validate,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 32, right: 16, left: 16),
                          child: Text(
                            tr('resetPassword'),
                            style: const TextStyle(
                              fontSize: 25
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32, left: 24, right: 24),
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.done,
                            validator: Helper.validateEmail,
                            onFieldSubmitted: (_) => context
                              .read<ResetPasswordCubit>()
                              .checkValidField(_key),
                            onSaved: (val) => _email = val!,
                            style: const TextStyle(fontSize: 18.0),
                            keyboardType: TextInputType.emailAddress,
                            decoration: Helper.getInputDecoration(
                              hint: 'E-mail',
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 40, left: 40, top: 40),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              )
                            ),
                            child: Text(
                              tr('sendEmail'),
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            onPressed: () => context
                              .read<ResetPasswordCubit>()
                              .checkValidField(_key),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
