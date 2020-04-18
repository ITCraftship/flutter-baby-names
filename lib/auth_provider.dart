import 'package:flutter/cupertino.dart';
import 'package:name_voter/auth.dart';

class AuthProvider extends InheritedWidget {
  final BaseAuth auth;

  AuthProvider({Key key, Widget child, this.auth})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static AuthProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthProvider>();
}
