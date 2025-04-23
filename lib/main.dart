import 'package:airplane_management/e_ticket_interface.dart';
import 'package:airplane_management/interface/results_interface.dart';
import 'package:airplane_management/offers_coupons_interface.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'interface/main_interface.dart';
import 'interface/flight_check_interface.dart';
import 'interface/user_profile_interface.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(TicketBookingApp());
}

class TicketBookingApp extends StatelessWidget {
  const TicketBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkyFly - Ticket Booking',
      theme: ThemeData(
        primaryColor: Colors.purple[800],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.redAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[100],
        fontFamily: 'Poppins',
      ),
      home: UserProfileInterface(),
      routes: {
        '/results': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>?;
          return ResultsInterface(
            from: args?['fromCity'] ?? 'Unknown',
            to: args?['toCity'] ?? 'Unknown',
          );
        },
        '/flightCheck': (context) => FlightCheckInterface(),
        '/userProfile': (context) => UserProfileInterface(),
        '/offers': (context) => OffersCouponsInterface(),
        '/eticket': (context) => ETicketInterface(
            ticketData: const {}), // You may need to adjust this
        '/mainInterface': (context) => MainInterface(),
      },
    );
  }
}
