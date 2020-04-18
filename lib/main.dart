import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:name_voter/auth.dart';
import 'package:name_voter/auth_provider.dart';
import 'package:name_voter/validators.dart';

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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String _email, _password;
  FormType _formType = FormType.login;

  bool validate() {
    final form = formKey.currentState;
    form.save();

    if (form.validate()) {
      return true;
    }
    return false;
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          String userId =
              await auth.signInWithEmailAndPassword(_email, _password);

          print('Signed in $userId');
        } else {
          String userId =
              await auth.createUserWithEmailAndPassword(_email, _password);

          print('Registered $userId');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void switchFormState(FormType formType) {
    formKey.currentState.reset();
    setState(() {
      _formType = formType;
    });
  }

  void signInWithGoogle() async {
    try {
      final _auth = AuthProvider.of(context).auth;
      final id = await _auth.signInWithGoogle();
      print('signed in with google $id');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Baby Name Votes')),
      body: Center(
        child: Form(
          key: formKey,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: buildInputs() + buildButtons(),
              )),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
          validator: EmailValidator.validate,
          decoration: InputDecoration(labelText: 'Email'),
          onSaved: (value) => _email = value),
      TextFormField(
          validator: PasswordValidator.validate,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          onSaved: (value) => _password = value),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        Container(
          margin: EdgeInsets.only(top: 16),
          child: RaisedButton(
              onPressed: () {
                submit();
              },
              child: Text('Login')),
        ),
        FlatButton(
          onPressed: () {
            switchFormState(FormType.register);
          },
          child: Text('Register'),
        ),
        FlatButton(
          child: Text('Sign in with Google'),
          onPressed: signInWithGoogle,
        )
      ];
    } else {
      return [
        Container(
          margin: EdgeInsets.only(top: 16),
          child: RaisedButton(
              onPressed: () {
                submit();
              },
              child: Text('Create account')),
        ),
        FlatButton(
          onPressed: () {
            switchFormState(FormType.login);
          },
          child: Text('Go to Login'),
        )
      ];
    }
  }
}

class NameListPage extends StatefulWidget {
  @override
  _NameListPageState createState() {
    return _NameListPageState();
  }
}

class _NameListPageState extends State<NameListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Baby Name Votes'),
        actions: <Widget>[
          FlatButton(
              onPressed: () async {
                try {
                  Auth auth = AuthProvider.of(context).auth;
                  await auth.signOut();
                } catch (e) {
                  print(e);
                }
              },
              child: Text('Sign out'))
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // TODO: create the Firestore instance from the app:
      // https://stackoverflow.com/questions/57015539/flutter-firestore-authentication
      stream: Firestore.instance.collection('baby').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(record.name),
          trailing: Text(record.votes.toString()),
          onTap: () async {
            Auth auth = AuthProvider.of(context).auth;
            final userId = await auth.currentUser();
            final name = record.reference.documentID;
            await Firestore.instance
                .collection('votes')
                .document(userId)
                .collection('names')
                .document(name)
                .setData({'vote': true});
          },
        ),
      ),
    );
  }
}

class Record {
  final String name;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$name:$votes>";
}
