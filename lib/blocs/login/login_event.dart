import 'package:flutter/cupertino.dart';

abstract class LoginEvent {}

class ValidateLoginFieldsEvent extends LoginEvent {
  GlobalKey<FormState> key;

  ValidateLoginFieldsEvent(this.key);
}