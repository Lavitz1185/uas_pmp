import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Signup
  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = 'Some Error Occured';
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name': name,
        'email': email,
        'uid': credential.user!.uid,
      });
      res = 'success';
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  //login
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some Error Occurated';
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = 'success';
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  //logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
