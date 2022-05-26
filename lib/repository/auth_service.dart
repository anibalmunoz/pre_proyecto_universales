import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pre_proyecto_universales/models/user_model.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:pre_proyecto_universales/pages/home_page/home_page.dart';
import 'package:pre_proyecto_universales/providers/fingerprint.dart';
import 'package:pre_proyecto_universales/repository/chat_service.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UsuarioModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }

    return UsuarioModel(
      uid: user.uid,
      email: user.email,
    );
  }

  Stream<UsuarioModel?>? get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  UsuarioModel getUsuario() {
    final User? user = _firebaseAuth.currentUser;
    //print(user!);
    return UsuarioModel(
      uid: user!.uid,
      email: user.email ?? "",
      name: user.displayName ?? "",
      photoURL: user.photoURL ?? "",
    );
  }

  Future<UsuarioModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(credential.user);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future createUserWithEmailAndPassword(
      context, String email, String password) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pop(context);
      _userFromFirebase(credential.user);
      await ChatService.shared.crearORegistrarCanalGeneral(getUsuario());
      // await mostrarFlushbar(context, 'Cuenta creada correctamente',
      //     '¡Disfruta de nuestra app de chats desde ya!');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      mostrarFlushbar(context, 'Correo actualmente en uso',
          'Por favor utiliza otro correo');
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    return await _firebaseAuth.signOut();
  }

  /* GOOGLE */

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
      await ChatService.shared.crearORegistrarCanalGeneral(getUsuario());
      Fingerprint.suprimirSharedPreferences("null", "null");
    } catch (e) {
      print(e.toString());
    }
  }

/*FACEBOOK */

  Future/*<UserCredential>*/ signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.accessToken != null) {
        // Create a credential from the access token
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);

        await _firebaseAuth.signInWithCredential(facebookAuthCredential);
        await ChatService.shared.crearORegistrarCanalGeneral(getUsuario());

        Fingerprint.suprimirSharedPreferences("null", "null");
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  /* TWITTER */

  Future/*<UserCredential>*/ signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
          apiKey: 'H31JlrCMKPuRIHXJCAdcLu0Ts',
          apiSecretKey: 'rVVC37WNZ90XvihipgJDcCwE0O7BjxwxcVfPZyCePtlUIb71jM',
          redirectURI: 'flutter-twitter-login://');

      twitterLogin.login().then(
        (value) async {
          final twitterAuthCredential = TwitterAuthProvider.credential(
              accessToken: value.authToken!, secret: value.authTokenSecret!);
          await _firebaseAuth.signInWithCredential(twitterAuthCredential);
          await ChatService.shared.crearORegistrarCanalGeneral(getUsuario());
        },
      );
      Fingerprint.suprimirSharedPreferences("null", "null");
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

/* */
  mostrarFlushbar(context, String title, String message) async {
    await Flushbar(
      title: title,
      message: message,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.only(top: 8, bottom: 55.0, left: 8, right: 8),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
