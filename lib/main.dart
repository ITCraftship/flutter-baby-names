import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:name_voter/pages/tabbar_page.dart';
import 'package:name_voter/pages/login_page.dart';
import 'package:name_voter/services/auth/auth.dart';
import 'package:name_voter/services/names_service/names_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<BaseAuth>(
          create: (context) => Auth(),
        ),
        Provider<NamesServiceBase>(
          create: (context) => NamesService(),
        ),
      ],
      child: MaterialApp(
        title: 'Baby Names',
        home: LoginSwitcher(),
        theme: ThemeData.dark(),
      ),
    );
  }
}

class LoginSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = Provider.of<BaseAuth>(context);
    return StreamBuilder<String>(
        stream: auth.onAuthStateChanged,
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final bool loggedIn = snapshot.hasData;
            return !loggedIn ? LoginPage() : TabBarPage();
          }
          return CircularProgressIndicator();
        });
  }
}
