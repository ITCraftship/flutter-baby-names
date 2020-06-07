import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:name_voter/models/validators.dart';
import 'package:name_voter/services/auth/auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Baby Name Votes')),
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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

  Future<void> submit() async {
    if (validate()) {
      try {
        final auth = Provider.of<BaseAuth>(context, listen: false);
        if (_formType == FormType.login) {
          final String userId =
              await auth.signInWithEmailAndPassword(_email, _password);

          print('Signed in $userId');
        } else {
          final String userId =
              await auth.createUserWithEmailAndPassword(_email, _password);

          print('Registered $userId');
        }
      } on PlatformException catch (e) {
        // TODO: we could handle specific codes like 'ERROR_WEAK_PASSWORD', but we'll just handle this generically
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.warning,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              Expanded(
                  child: Text(
                e.message,
              ))
            ],
          ),
        ));
      }
    }
  }

  void switchFormState(FormType formType) {
    formKey.currentState.reset();
    setState(() {
      _formType = formType;
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      final auth = Provider.of<BaseAuth>(context, listen: false);
      final id = await auth.signInWithGoogle();
      print('signed in with google $id');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: buildInputs() + buildButtons(),
          )),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
          validator: EmailValidator.validate,
          decoration: const InputDecoration(labelText: 'Email'),
          onSaved: (value) => _email = value),
      TextFormField(
          validator: PasswordValidator.validate,
          decoration: const InputDecoration(labelText: 'Password'),
          obscureText: true,
          onSaved: (value) => _password = value),
    ];
  }

  List<Widget> buildButtons() {
    if (_formType == FormType.login) {
      return [
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: RaisedButton(
              onPressed: () {
                submit();
              },
              child: const Text('Login')),
        ),
        FlatButton(
          onPressed: () {
            switchFormState(FormType.register);
          },
          child: const Text('Register'),
        ),
        FlatButton(
          onPressed: signInWithGoogle,
          child: const Text('Sign in with Google'),
        )
      ];
    } else {
      return [
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: RaisedButton(
              onPressed: () {
                submit();
              },
              child: const Text('Create account')),
        ),
        FlatButton(
          onPressed: () {
            switchFormState(FormType.login);
          },
          child: const Text('Go to Login'),
        )
      ];
    }
  }
}
