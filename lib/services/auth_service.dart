import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<MyUser> getCurrentUser() async {
    var userDocSnapshot = await _firestore.collection('users').doc(currentUser!.uid).get();
    if (userDocSnapshot.exists) {
      return MyUser.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  Future<MyUser?> getCurrentUserNullable() async {
    if (currentUser != null) {
      var userDocSnapshot = await _firestore.collection('users').doc(
          currentUser!.uid).get();
      if (userDocSnapshot.exists) {
        return MyUser.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception('Test1: User not found');
      }
    } else {
      return Future.value(null);
    }
  }
  Future<MyUser> getUserById(String userId) async {
    var userDocSnapshot = await _firestore.collection('users').doc(userId).get();
    if (userDocSnapshot.exists) {
      return MyUser.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }


  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}