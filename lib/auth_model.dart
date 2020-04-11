import 'package:flutter/material.dart';
import 'package:name_voter/auth.dart';

class AuthModel extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void setAuthenticated(bool authenticated) {
    _isAuthenticated = authenticated;
    notifyListeners();
  }
}
