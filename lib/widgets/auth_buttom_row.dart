import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

class AuthButtonsRow extends StatelessWidget {
  final bool isLogin;
  final VoidCallback switchAuthMode;

  const AuthButtonsRow(
      {Key? key, required this.isLogin, required this.switchAuthMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isLogin ? tr('not_a_member') : tr('already_have_account'),
          textAlign: TextAlign.end,
        ),
        Container(
          margin: const EdgeInsets.only(
            right: 10,
            left: 10,
          ),
          child: const Text('/'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(
              vertical: 4, 
              horizontal: 1,)
            ,
          ),
          onPressed: switchAuthMode,
          child: Text(
            isLogin ? tr('signup') : tr('login'),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}