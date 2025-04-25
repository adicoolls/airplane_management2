import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during sign in';
    }
  }

  // Register with email and password
  Future<UserCredential?> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during registration';
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

import 'package:http/http.dart' as http;

class FlightApiService {
  final String baseUrl = 'your_api_base_url'; // Replace with your actual API base URL

  Future<List<Flight>> fetchFlights() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/flights')); // Replace '/flights' with the correct endpoint

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<Flight> flights = body.map((dynamic item) => Flight.fromJson(item)).toList();
        return flights;
      } else {
        throw Exception('Failed to load flights: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load flights: $e');
    }
  }
}

class Flight {
  final String flightNumber;
  final String airlineName;
  final String from;
  final String to;
  final String departureTime;
  final String arrivalTime;
  final double price;
  final String date;

  Flight({
    required this.flightNumber,
    required this.airlineName,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.date,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight.fromMap(json);
  }
  factory Flight.fromMap(Map<String, dynamic> map) => Flight(flightNumber: map["flightNumber"] ,airlineName: map["airlineName"], from: map["from"], to: map["to"], departureTime: map["departureTime"], arrivalTime: map["arrivalTime"], price: map["price"], date: map["date"]);
}
