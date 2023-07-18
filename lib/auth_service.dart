import 'package:chat_app/chat_list.dart';
import 'package:chat_app/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth/login_page.dart';

late String userName, userPhoto;

class AuthService {
  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        FirebaseAuth auth = FirebaseAuth.instance;
        if (snapshot.hasData) {
          if (FirebaseAuth.instance.currentUser!.metadata.creationTime ==
              FirebaseAuth.instance.currentUser!.metadata.lastSignInTime && auth.currentUser!.displayName!=null) {
            addUserDataToFirestore();
          }
          return const ChatList();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  signInWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    }
    else if(defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS){
          // Trigger the authentication flow

          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

          // Obtain the auth details from the request
          final GoogleSignInAuthentication? googleAuth =
              await googleUser?.authentication;

          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          // Once signed in, return the UserCredential
          return await FirebaseAuth.instance.signInWithCredential(credential);
    }
    else{
      showSnackBar(context, "Platform do not support login");
    }

  }
  signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await GoogleSignIn().signOut();
    }
    showSnackBar(context, "User is signed out.");
    print("User is signed out.");
  }


  createUserWithEmailAndPassword(String name, String emailAddress,
      String password, BuildContext context) async {
    try {
      final userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      FirebaseAuth auth = FirebaseAuth.instance;
      await auth.currentUser!.updateDisplayName(name);
      print(auth.currentUser!.displayName);

      signInWithEmailAndPassword(emailAddress, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  signInWithEmailAndPassword(String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  addUserDataToFirestore() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .set({
      "name": auth.currentUser!.displayName,
      "email": auth.currentUser!.email,
      "status": "unavailable",
      "uId": auth.currentUser!.uid
    });
  }
}
