import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:name_voter/services/auth/auth.dart';
import 'package:name_voter/services/auth/auth_provider.dart';
import 'package:name_voter/pages/login_page.dart';
import 'package:name_voter/pages/name_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Baby Names',
        home: StartPage(),
        theme: ThemeData.dark(),
      ),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Auth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool loggedIn = snapshot.hasData;
            return !loggedIn ? LoginPage() : NameListPage();
          }
          return CircularProgressIndicator();
        });
  }
}
