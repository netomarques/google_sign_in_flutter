import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDatasource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthDatasource(this._auth, this._firestore);

  Future<bool> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) return false;

    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    try {
      final result = await _auth.signInWithCredential(oauthCredentials);
      final user = result.user;

      await _firestore.collection('users').doc(user?.uid).set({
        'username': user?.displayName,
        'email': user?.email,
        'userId': user?.uid,
        'imgUrl': user?.photoURL,
      });

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      GoogleSignIn().signOut(),
    ]);
  }

  Stream<User?> authStateChanges() async* {
    yield* _auth.authStateChanges();
  }

  Stream<QuerySnapshot<Object?>> getCurrentUser() async* {
    await _auth.currentUser?.reload();
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      yield* _firestore
          .collection('users')
          .where('userId', isEqualTo: currentUser.uid)
          .limit(1)
          .snapshots();
    }
  }
}
