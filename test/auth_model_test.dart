import 'package:flutter_test/flutter_test.dart';

import 'package:name_voter/models/auth_model.dart';

void main() {
  group('setAuthenticated should', () {
    test('change authentication state and notify listeners', () {
      final auth = AuthModel(null);
      expect(auth.isAuthenticated, isFalse);
      auth.addListener(() {
        expect(auth.isAuthenticated, isTrue);
      });
      auth.setAuthenticated(true);
    });
  });
}
