import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurants_app/models/models.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference _restaurants =
      FirebaseFirestore.instance.collection('restaurants');
  final CollectionReference _reservations =
      FirebaseFirestore.instance.collection('reservations');

  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> addUser(Client client) {
    // Call the user's CollectionReference to add a new user
    String uid = _firebaseAuth.currentUser.uid;
    return _users
        .doc(uid)
        .set(client.toMap())
        .then((value) => _users.doc(uid).update({'id': uid}));
  }

  Future<String> getRole() async {
    // gets the role of the user who is trying to log in
    String uid = _firebaseAuth.currentUser.uid;
    DocumentSnapshot snapShot = await _users.doc(uid).get();
    return snapShot['role'];
  }

  Future<Client> getUser() async {
    // gets the user data from DB and returns a user instance
    String uid = _firebaseAuth.currentUser.uid;
    DocumentSnapshot snapShot = await _users.doc(uid).get();
    return Client.fromMap(snapShot.data());
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    final QuerySnapshot querySnapshot = await _restaurants.get();
    return querySnapshot.docs
        .map((doc) => Restaurant.fromMap(doc.data()))
        .toList();
  }

  Future<Restaurant> getRestaurant(String restaurantId) async {
    // Gets the restaurant data from DB and returns a Restaurant instance
    final DocumentSnapshot snapShot =
        await _restaurants.doc(restaurantId).get();
    return Restaurant.fromMap(snapShot.data());
  }

  Future<void> addRestaurant(Restaurant restaurant) {
    // Call the Restaurants' CollectionReference to add a new restaurant
    String uid = _firebaseAuth.currentUser.uid;
    DocumentReference newRestRef = _restaurants.doc();
    return newRestRef.set(restaurant.toMap()).then((value) {
      _users.doc(uid).update({'restaurantId': newRestRef.id});
      newRestRef.update({'id': newRestRef.id, 'adminId': uid});
    });
  }

  Future<void> addReservation(Reservation reservation) {
    // Call the reservations' CollectionReference to add a new reservation
    DocumentReference newResRef = _reservations.doc();
    return newResRef.set(reservation.toMap()).then((value) {
      newResRef.update({'id': newResRef.id});
    });
  }

  Future<List<Reservation>> getAllReservations(String userId) async {
    final QuerySnapshot querySnapshot =
        await _reservations.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) => Reservation.fromMap(doc.data()))
        .toList();
  }

  Future<void> registerMenu(
      Restaurant restaurant, Map<String, Map<String, double>> menu) {
    return _restaurants.doc(restaurant.id).update({'menu': menu});
  }

  Future<void> changeReservationState(String id, String newState) {
    return _reservations.doc(id).update({'state': newState}).then(
        (value) => print('Reservation State Changed'));
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
