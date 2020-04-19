import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class BaseAuth {
  Stream<String> get onAuthStateChanged;
  Future<String> signInWithEmailAndPassword(String email, String password);
  Future<String> createUserWithEmailAndPassword(String email, String password);

  Future<String> currentUser();
  Future<void> signOut();
  Future<String> signInWithGoogle();
}

class Auth implements BaseAuth {
  // TODO: create the instance from the app:
  // https://stackoverflow.com/questions/57015539/flutter-firestore-authentication
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map((FirebaseUser user) => user?.uid);

  @override
  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  @override
  Future<String> currentUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  @override
  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password))
        .user
        .uid;
  }

  @override
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    if (account == null) {
      throw new Exception('Google login failed');
    }
    final GoogleSignInAuthentication auth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: auth.idToken, accessToken: auth.accessToken);

    final user = (await _firebaseAuth.signInWithCredential(credential)).user;
    return user.uid;
  }

  @override
  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
