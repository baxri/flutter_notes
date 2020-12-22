import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter_notes/models/models.dart';
import 'package:flutter_notes/repositories/repositories.dart';
import 'package:flutter_notes/entities/entities.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;

  @override
  Future<User> getCurrentUser() async {
    final currenctUser = _firebaseAuth.currentUser;

    if (currenctUser == null) {
      return null;
    }

    return await _firebaseuserTouser(currenctUser);
  }

  @override
  bool isAnonymous() {
    return _firebaseAuth.currentUser.isAnonymous;
  }

  @override
  Future<User> loginAnonymously() async {
    final firebase_auth.UserCredential authResult =
        await _firebaseAuth.signInAnonymously();
    return await _firebaseuserTouser(authResult.user);
  }

  @override
  Future<User> loginWithEmailAndPassword(String email, String password) async {
    final firebase_auth.UserCredential authResult = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return await _firebaseuserTouser(authResult.user);
  }

  @override
  Future<User> logout() async {
    await _firebaseAuth.signOut();
    return await loginAnonymously();
  }

  @override
  Future<User> signUpWithEmailAndPassword(String email, String password) async {
    final currentUser = _firebaseAuth.currentUser;
    final authCredential = firebase_auth.EmailAuthProvider.credential(
        email: email, password: password);

    final firebase_auth.UserCredential authResult =
        await currentUser.linkWithCredential(authCredential);

    final user = await _firebaseuserTouser(authResult.user);

    _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toEntity().toDocument());

    return await _firebaseuserTouser(authResult.user);
  }

  Future<User> _firebaseuserTouser(firebase_auth.User firebaseUser) async {
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();

    if (userDoc.exists) {
      return User.fromEntity(UserEntity.fromSnapshot(userDoc));
    }

    return User(id: firebaseUser.uid, email: '');
  }

  @override
  void dispose() {}
}
