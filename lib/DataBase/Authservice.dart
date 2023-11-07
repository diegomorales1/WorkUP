import 'package:firebase_auth/firebase_auth.dart';
import 'package:logincloud/DataBase/User.dart';
import 'package:logincloud/DataBase/database.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // creates a firebase instance to be used ie creating an anonymous user

  //create user obj based on FirebaseUser
  Usuario _userFromFirebaseUser(User user) {
    return user != null ? Usuario(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<Usuario> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser); //Esto estaba: _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //get the user
  Future getUser() async {
    var firebaseUser = await _auth.currentUser;
    return Usuario(uid: firebaseUser.uid);
  }

  //sign in anon
  Future signinAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      //creates anonymous user via a firebase instance
      User user = result.user;
      //takes out the user

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.tostring());
      return null;
    }
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email,
      String password,
      String name,
      String dp,
      String media,) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      //create document for each user in registration
      await DatabaseService(uid: user.uid).uploadUserData(
          email, name, media);
      //await DatabaseService(uid: user.uid).uploadWhoData(
      //    email: email,
      //    name: name,);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //validate curren password
  Future validatePassword(String password) async {
    var baseUser = await _auth.currentUser;

    // var authCrudentials = EmailAuthProvider.getCredential(
    //     email: firebaseUser.email, password: password);
    // print(authCrudentials);

    try {
      //sign in method is used instead of reauthenticate with credential because
      //it was buggy
      var firebaseUser = await _auth.signInWithEmailAndPassword(
          email: baseUser.email, password: password);
      return firebaseUser != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _auth.currentUser;
    firebaseUser.updatePassword(password);
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}