import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  // Sign Up

  Future<String?> signUp(String name, String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      AppUser user = AppUser(
        uid: result.user!.uid,
        name: name,
        email: email,
        streak: 0,
        photoUrl: "",
      );

      await db.collection("users").doc(user.uid).set(user.toMap());

      return null;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Signup failed";
    }
  }

  // Login
  // Future<User?> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     return result.user;
  //   } on FirebaseAuthException catch (e) {
  //     throw e.message ?? "Login failed";
  //   }
  // }
  Future<String?> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }


  // RESET PASSWORD
  Future<String?> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Something went wrong, try again!";
    }
  }
  //Logout
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw "Logout failed";
    }
  }

}

class UserService {
  final db = FirebaseFirestore.instance;

  Stream<DocumentSnapshot> userStream() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return db.collection("users").doc(uid).snapshots();
  }

  Future<Map<String, dynamic>?> getUser() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snap = await db.collection("users").doc(uid).get();

    if (snap.exists) {
      return snap.data() as Map<String, dynamic>;
    }
    return null;
  }
}
