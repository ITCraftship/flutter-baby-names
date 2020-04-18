import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:name_voter/services/auth/auth.dart';
import 'package:name_voter/services/auth/auth_provider.dart';
import 'package:name_voter/pages/login_page.dart';
import 'package:name_voter/pages/name_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'names',
    options: const FirebaseOptions(
      googleAppID: '1:386140118086:ios:a7cd9c0062f7cdb9577e47',
      gcmSenderID: '386140118086',
      apiKey: 'AIzaSyDA92YYyAlAlvjZWL4SQM2ITNh1lWjk_VU',
      projectID: 'flutter-baby-names-78d1e',
    ),
  );

  runApp(MyApp(
    fbApp: app,
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseApp _fbApp;

  const MyApp({Key key, fbApp})
      : _fbApp = fbApp,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(_fbApp),
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
