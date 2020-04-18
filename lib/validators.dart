import 'package:name_voter/string_extension.dart';

enum FormType { login, register }

class EmptyValidator {
  static String validate(String fieldName, String value) {
    return value.isEmpty ? "${fieldName.capitalize()} can't be empty" : null;
  }
}

class EmailValidator {
  static String validate(String value) {
    return EmptyValidator.validate('email', value);
  }
}

class PasswordValidator {
  static String validate(String value) {
    return EmptyValidator.validate('password', value);
  }
}
