import 'package:flutter/material.dart';

import 'package:name_voter/services/auth/auth.dart';

// this is temporary, not removing this cause I may want to encapsulate firebase better within the app using models
class AuthModel extends ChangeNotifier {
  BaseAuth _auth;
  bool _isAuthenticated = false;

  AuthModel(this._auth);

  bool get isAuthenticated => _isAuthenticated;

  void setAuthenticated(bool authenticated) {
    _isAuthenticated = authenticated;
    notifyListeners();
  }
}
