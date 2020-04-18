import 'package:flutter/material.dart';
import 'package:name_voter/auth.dart';

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
