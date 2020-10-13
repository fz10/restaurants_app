import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> addUser(String role, String email) {
    // Call the user's CollectionReference to add a new user
    String uid = _firebaseAuth.currentUser.uid;
    return _users.doc(uid).set({
      'role': role,
      'email': email,
    });
  }

  Future<String> getRole() async {
    // Call the user's CollectionReference to add a new user
    String uid = _firebaseAuth.currentUser.uid;
    var document = await _users.doc(uid).get();
    return document.data()['role'];
  }

  Future<void> signInWithCredentials(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp({String email, String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUserId() async {
    return _firebaseAuth.currentUser.uid;
  }
}
