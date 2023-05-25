import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;
  Rx<User?> _firebaseUser = Rx<User?>(null);

  User? get user => _firebaseUser.value;
  bool isRegister = false;
  bool registerInProgress = false;
  bool loginInProgress = false;
  bool isLogin = false;

  Future<bool> register(
      String userType, String userName, String email, String password) async {
    registerInProgress = true;
    update();
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser.value = userCredential.user;

      // Save user information to Firestore
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
          {'id': uid, 'name': userName, 'email': email, 'userType': userType});
      registerInProgress = false;
      update();

      return isRegister = true;

    } catch (e) {
      // Handle registration error
      registerInProgress = false;
      log('Registration error: $e');
      update();
      return isRegister = false;

    }
  }

  Future<String?> login(String email, String password) async {
    loginInProgress = true;
    update();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser.value = userCredential.user;
      loginInProgress = false;
      update();
      if (userCredential.user!.uid != null) {
        return userCredential.user?.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      } else {
        return e.message;
      }
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> fetchUserData(
      String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      print(userDoc);
      return userDoc;
    } catch (e) {
      // Handle error
      log('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _firebaseUser.value = null;

    } catch (e) {
      // Handle logout error
      log('Logout error: $e');
    }
  }
}
