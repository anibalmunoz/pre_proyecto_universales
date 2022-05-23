import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String mailFacebook;
  late String fotoFacebook;

  Usuario? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }

    return Usuario(
      uid: user.uid,
      email: user.email,
    );
  }

  Stream<Usuario?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  Usuario getUsuario() {
    final User? user = _firebaseAuth.currentUser;
    // if (user != null) {
    print(user!.photoURL);

    return Usuario(
      uid: user.uid,
      email: user.email,
      name: user.displayName,
      photoURL: user.photoURL,
    );
  }

  Future<Usuario?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<Usuario?> createUserWithEmailAndPassword(
      context, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      mostrarFlushbarCorreoYaUtilizado(context, 'Correo actualmente en uso',
          'Por favor utiliza otro correo');
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    return await _firebaseAuth.signOut();
  }

  //sigin with google

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _googleUser;

  GoogleSignInAccount get googleUser => _googleUser!;

  Future googleLogin() async {
    try {
      final googleUserC = await googleSignIn.signIn().catchError((onError) {
        print(onError);
      });

      if (googleUserC == null) return;

      _googleUser = googleUserC;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
  }

//fin sigin whith google

/*FACEBOOK */

  Future/*<UserCredential>*/ signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      final userData = await FacebookAuth.instance.getUserData();

      mailFacebook = userData["email"];
      //fotoFacebook = userData['public_profile'];

      // /**/
      // final credential = await _firebaseAuth.(
      //       email: email, password: password);
      //   return _userFromFirebase(credential.user);
      // /* */

      // Once signed in, return the UserCredential
      return _firebaseAuth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

/* */

  mostrarFlushbarCorreoYaUtilizado(
      context, String title, String message) async {
    Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 8, bottom: 55.0, left: 8, right: 8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
