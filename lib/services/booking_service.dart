import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/airplane_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveFlightBooking(Datum flight) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .add({
        'flightNumber': flight.flight?.iata,
        'airline': flight.airline?.name,
        'from': flight.departure?.airport,
        'to': flight.arrival?.airport,
        'date': flight.departure?.scheduled,
        'status': flight.flightStatus,
        'terminal': flight.departure?.terminal,
        'gate': flight.departure?.gate,
        'bookingDate': DateTime.now(),
      });
    } catch (e) {
      throw 'Failed to save booking: $e';
    }
  }

  Stream<QuerySnapshot> getBookingHistory() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .orderBy('bookingDate', descending: true)
          .snapshots();
    }
    return const Stream.empty();
  }
}
