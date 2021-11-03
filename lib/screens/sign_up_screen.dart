import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({ Key? key }) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Helper.isDarkMode(context) ? Colors.white : Colors.black,
        ),
      ),
      body: Container(
        child: Text(tr('signUp')),
      ),
    );
  }
}