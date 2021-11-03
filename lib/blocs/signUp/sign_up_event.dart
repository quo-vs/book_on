import 'package:flutter/cupertino.dart';

abstract class SignUpEvent {}

class ValidateFieldsEvent extends SignUpEvent {
  GlobalKey<FormState> key;

  ValidateFieldsEvent(this.key);
}

