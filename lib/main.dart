import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:name_voter/blocs/name_votes/name_votes_bloc.dart';
import 'package:provider/provider.dart';

import 'package:name_voter/pages/tabbar_page.dart';
import 'package:name_voter/pages/login_page.dart';
import 'package:name_voter/services/auth/auth.dart';
import 'package:name_voter/repositories/name_votes/name_votes_repository.dart';

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
      ],
      child: MaterialApp(
        title: 'Baby Names',
        home: LoginSwitcher(),
        theme: ThemeData.dark().copyWith(
            snackBarTheme: ThemeData.dark().snackBarTheme.copyWith(
                contentTextStyle: TextStyle(
                    color: ThemeData.dark().textTheme.bodyText1.color),
                backgroundColor: ThemeData.dark().dialogBackgroundColor)),
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
            final String userId = snapshot.data;
            return !loggedIn
                ? LoginPage()
                : MultiBlocProvider(providers: [
                    BlocProvider<NameVotesBloc>(
                      create: (context) {
                        return NameVotesBloc(
                            nameVotesRepository:
                                FirestoreNameVotesRepository(userId))
                          ..add(LoadNameVotes());
                      },
                    )
                  ], child: TabBarPage());
          }
          return CircularProgressIndicator();
        });
  }
}
