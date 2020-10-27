import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurants_app/models/models.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection('restaurants');

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> addUser(Client client) {
    // Call the user's CollectionReference to add a new user
    String uid = _firebaseAuth.currentUser.uid;
    return _users.doc(uid).set(client.toMap());
  }

  Future<bool> getRole(String role) async {
    // gets the role of the user who is trying to log in
    String uid = _firebaseAuth.currentUser.uid;
    bool isRoleValid;
    DocumentSnapshot snapShot = await _users.doc(uid).get();
    if (snapShot['role'] == role) {
      isRoleValid = true;
    } else {
      isRoleValid = false;
    }
    return isRoleValid;
  }

  Future<void> addRestaurant(Restaurant restaurant) {
    // Call the user's CollectionReference to add a new user
    String uid = _firebaseAuth.currentUser.uid;
    var newRestRef = _restaurants.doc();
    return newRestRef
        .set(restaurant.toMap())
        .then((value) => newRestRef.update({'adminId': uid}));
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
