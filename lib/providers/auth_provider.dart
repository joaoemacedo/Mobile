import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_4/models/restaurant.dart';
import 'package:flutter_application_4/models/reservation.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isAuthenticated = false;
  String _loggedInUserEmail = '';
  Restaurant? _restaurant;

  bool get isAuthenticated => _isAuthenticated;
  String get loggedInUserEmail => _loggedInUserEmail;
  Restaurant? get restaurant => _restaurant;

  Future<void> register(String email, String password, String restaurantName, String city, String state) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(email).set({
        'restaurantName': restaurantName,
        'city': city,
        'state': state,
        'operatingDays': [],
        'openingTime': null,
        'closingTime': null,
        'tables': 0,
        'maxPeoplePerReservation': 0,
        'imageUrl': '',
      });

      _isAuthenticated = true;
      _loggedInUserEmail = email;

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(email).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        _isAuthenticated = true;
        _loggedInUserEmail = email;
        _restaurant = Restaurant(
          name: userData['restaurantName'],
          city: userData['city'],
          state: userData['state'],
          operatingDays: List<String>.from(userData['operatingDays']),
          openingTime: _convertTimestampToTimeOfDay(userData['openingTime']),
          closingTime: _convertTimestampToTimeOfDay(userData['closingTime']),
          tables: userData['tables'],
          maxPeoplePerReservation: userData['maxPeoplePerReservation'],
          imageUrl: userData['imageUrl'] ?? '',
        );

        notifyListeners();
      } else {
        throw Exception('No restaurant found for this user');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _isAuthenticated = false;
    _loggedInUserEmail = '';
    _restaurant = null;
    notifyListeners();
  }

  Future<List<Restaurant>> getAllRestaurants() async {
    try {
      QuerySnapshot restaurantSnapshot = await _firestore.collection('users').get();

      List<Restaurant> allRestaurants = [];
      for (var doc in restaurantSnapshot.docs) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        Restaurant restaurant = Restaurant(
          name: userData['restaurantName'],
          city: userData['city'],
          state: userData['state'],
          operatingDays: List<String>.from(userData['operatingDays']),
          openingTime: _convertTimestampToTimeOfDay(userData['openingTime']),
          closingTime: _convertTimestampToTimeOfDay(userData['closingTime']),
          tables: userData['tables'],
          maxPeoplePerReservation: userData['maxPeoplePerReservation'],
          imageUrl: userData['imageUrl'] ?? '',
        );

        allRestaurants.add(restaurant);
      }

      return allRestaurants;
    } catch (e) {
      throw Exception('Failed to fetch all restaurants: $e');
    }
  }

  Future<List<Reservation>> getReservations() async {
    try {
      String email = _loggedInUserEmail;
      if (email.isEmpty || _restaurant == null) {
        throw Exception('User not authenticated or restaurant not found');
      }

      QuerySnapshot reservationSnapshot = await _firestore.collection('reservations').where('restaurantEmail', isEqualTo: email).get();

      List<Reservation> reservations = [];
      for (var doc in reservationSnapshot.docs) {
        Map<String, dynamic> reservationData = doc.data() as Map<String, dynamic>;

        Reservation reservation = Reservation(
          restaurantName: reservationData['restaurantName'],
          userEmail: reservationData['userEmail'],
          date: reservationData['date'].toDate(),
          time: _convertTimestampToTimeOfDay(reservationData['time']),
          numberOfPeople: reservationData['numberOfPeople'],
          observations: reservationData['observations'] ?? '',
          status: reservationData['status'], // Adicionei o status aqui
        );

        reservations.add(reservation);
      }

      return reservations;
    } catch (e) {
      throw Exception('Failed to fetch reservations: $e');
    }
  }

  Future<void> addReservation(Reservation reservation) async {
    try {
      String email = _loggedInUserEmail;
      if (email.isEmpty || _restaurant == null) {
        throw Exception('User not authenticated or restaurant not found');
      }

      await _firestore.collection('reservations').add({
        'restaurantEmail': email,
        'restaurantName': _restaurant!.name,
        'userEmail': reservation.userEmail,
        'date': reservation.date,
        'time': _convertTimeOfDayToTimestamp(reservation.time),
        'numberOfPeople': reservation.numberOfPeople,
        'observations': reservation.observations,
        'status': reservation.status, // Incluído o status aqui
      });

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add reservation: $e');
    }
  }

  Future<void> updateReservationStatus(Reservation reservation, String newStatus) async {
    try {
      String email = _loggedInUserEmail;
      if (email.isEmpty || _restaurant == null) {
        throw Exception('User not authenticated or restaurant not found');
      }

      await _firestore.collection('reservations').doc(reservation.userEmail).update({
        'status': newStatus,
      });

      reservation.status = newStatus; // Atualiza localmente
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update reservation status: $e');
    }
  }

  Future<void> updateRestaurantInfo(
    String restaurantName,
    String state,
    String city,
    TimeOfDay? openingTime,
    TimeOfDay? closingTime,
    int tables,
    int maxPeoplePerReservation,
    List<String> operatingDays,
    String imageUrl,
  ) async {
    try {
      String email = _loggedInUserEmail;
      if (email.isEmpty || _restaurant == null) {
        throw Exception('User not authenticated or restaurant not found');
      }

      await _firestore.collection('users').doc(email).update({
        'restaurantName': restaurantName,
        'state': state,
        'city': city,
        'operatingDays': operatingDays,
        'openingTime': _convertTimeOfDayToTimestamp(openingTime),
        'closingTime': _convertTimeOfDayToTimestamp(closingTime),
        'tables': tables,
        'maxPeoplePerReservation': maxPeoplePerReservation,
        'imageUrl': imageUrl,
      });

      _restaurant = Restaurant(
        name: restaurantName,
        state: state,
        city: city,
        operatingDays: operatingDays,
        openingTime: openingTime,
        closingTime: closingTime,
        tables: tables,
        maxPeoplePerReservation: maxPeoplePerReservation,
        imageUrl: imageUrl,
      );

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update restaurant info: $e');
    }
  }

  TimeOfDay _convertTimestampToTimeOfDay(Timestamp? timestamp) {
    if (timestamp == null) {
      return const TimeOfDay(hour: 0, minute: 0);
    }

    DateTime dateTime = timestamp.toDate();
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  Timestamp _convertTimeOfDayToTimestamp(TimeOfDay? timeOfDay) {
    if (timeOfDay == null) {
      return Timestamp.now();
    }

    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return Timestamp.fromDate(dateTime);
  }
}
