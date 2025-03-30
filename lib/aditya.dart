// import 'package:flutter/material.dart';
// class ResultsInterface extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final Map<String, String> args =
//         ModalRoute.of(context)!.settings.arguments as Map<String, String>;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Search Results'),
//         centerTitle: true,
//         backgroundColor: Colors.purple[800],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Flights from ${args['from']} to ${args['to']} on ${args['date']}',
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.purple,
//               ),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: 5,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     elevation: 3,
//                     margin: const EdgeInsets.symmetric(vertical: 8),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                     child: ListTile(
//                       leading: const Icon(Icons.flight, color: Colors.redAccent),
//                       title: Text('Flight ${index + 1}'),
//                       subtitle: const Text('Departure: 10:00 AM | Price: \$200'),
//                       trailing: const Icon(Icons.arrow_forward, color: Colors.purple),
//                       onTap: () {
//                         // Add booking logic
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class FlightCheckInterface extends StatelessWidget {
//   final TextEditingController _flightNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flight Status'),
//         centerTitle: true,
//         backgroundColor: Colors.purple[800],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const Text(
//               'Check Flight Status ✈️',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.purple,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _flightNumberController,
//               decoration: InputDecoration(
//                 labelText: 'Flight Number',
//                 prefixIcon: const Icon(Icons.confirmation_number, color: Colors.redAccent),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Add flight status check logic
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: const Text(
//                 'Check Status',
//                 style: TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// void main() => runApp(TicketBookingApp());

// class TicketBookingApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SkyFly - Ticket Booking',
//       theme: ThemeData(
//         primaryColor: Colors.purple[800],
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           secondary: Colors.redAccent,
//         ),
//         scaffoldBackgroundColor: Colors.grey[100],
//         fontFamily: 'Poppins',
//       ),
//       home: MainInterface(),
//       routes: {
//         '/results': (context) => ResultsInterface(),
//         '/flightCheck': (context) => FlightCheckInterface(),
//         '/userProfile': (context) => UserProfileInterface(),
//       },
//     );
//   }
// }

// class MainInterface extends StatelessWidget {
//   final TextEditingController _fromController = TextEditingController();
//   final TextEditingController _toController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SkyFly ✈️', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: Colors.purple[800],
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person, color: Colors.white),
//             onPressed: () {
//               Navigator.pushNamed(context, '/userProfile');
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               // Hero Section
//               Container(
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [Colors.purple[800]!, Colors.redAccent],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Where would you like to fly today? ✈️',
//                       style: TextStyle(
//                         fontSize: 24,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 20),
//                     // From Destination
//                     _buildInputField(
//                       controller: _fromController,
//                       label: 'From',
//                       icon: Icons.flight_takeoff,
//                     ),
//                     const SizedBox(height: 15),
//                     // To Destination
//                     _buildInputField(
//                       controller: _toController,
//                       label: 'To',
//                       icon: Icons.flight_land,
//                     ),
//                     const SizedBox(height: 15),
//                     // Date Picker
//                     _buildDatePicker(context),
//                     const SizedBox(height: 25),
//                     // Search Button
//                     _buildSearchButton(context),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               // Additional Options
//               _buildAdditionalOptions(),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => Navigator.pushNamed(context, '/flightCheck'),
//         backgroundColor: Colors.redAccent,
//         child: const Icon(Icons.airplanemode_active, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildInputField({
//     required TextEditingController controller,
//     required String label,
//     required IconData icon,
//   }) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         labelStyle: const TextStyle(color: Colors.white70),
//         prefixIcon: Icon(icon, color: Colors.white),
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.2),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: const TextStyle(color: Colors.white),
//     );
//   }

//   Widget _buildDatePicker(BuildContext context) {
//     return TextField(
//       controller: _dateController,
//       decoration: InputDecoration(
//         labelText: 'Date',
//         labelStyle: const TextStyle(color: Colors.white70),
//         prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.2),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//           borderSide: BorderSide.none,
//         ),
//       ),
//       style: const TextStyle(color: Colors.white),
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime.now(),
//           lastDate: DateTime(2025),
//         );
//         if (pickedDate != null) {
//           _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
//         }
//       },
//     );
//   }

//   Widget _buildSearchButton(BuildContext context) {
//     return ElevatedButton.icon(
//       onPressed: () {
//         if (_fromController.text.isNotEmpty &&
//             _toController.text.isNotEmpty &&
//             _dateController.text.isNotEmpty) {
//           Navigator.pushNamed(
//             context,
//             '/results',
//             arguments: {
//               'from': _fromController.text,
//               'to': _toController.text,
//               'date': _dateController.text,
//             },
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Please fill all fields!', style: TextStyle(color: Colors.white)),
//               backgroundColor: Colors.redAccent,
//             ),
//           );
//         }
//       },
//       icon: const Icon(Icons.search, color: Colors.white),
//       label: const Text('Search Flights', style: TextStyle(color: Colors.white)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.redAccent,
//         padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//     );
//   }

//   Widget _buildAdditionalOptions() {
//     return Column(
//       children: [
//         const Text(
//           'Popular Destinations 🌍',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 15),
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               _buildDestinationCard('Paris', '🇫🇷'),
//               _buildDestinationCard('Tokyo', '🇯🇵'),
//               _buildDestinationCard('New York', '🇺🇸'),
//             ],
//           ),
//         ),
//         const SizedBox(height: 25),
//         const Text(
//           'Special Offers 🔥',
//           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 15),
//         Container(
//           padding: const EdgeInsets.all(15),
//           decoration: BoxDecoration(
//             color: Colors.purple[100],
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Row(
//             children: [
//               const Icon(Icons.local_offer, color: Colors.redAccent),
//               const SizedBox(width: 10),
//               const Text('Get 20% OFF on first booking!'),
//               const Spacer(),
//               TextButton(
//                 onPressed: () {},
//                 child: const Text('CLAIM NOW', style: TextStyle(color: Colors.purple)),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDestinationCard(String city, String flag) {
//     return Container(
//       margin: const EdgeInsets.only(right: 15),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Text(flag, style: const TextStyle(fontSize: 24)),
//           const SizedBox(width: 10),
//           Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }

// class UserProfileInterface extends StatelessWidget {
//   final bool isLoggedIn = false; // Change this to manage login state
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         backgroundColor: Colors.purple[800],
//       ),
//       body: isLoggedIn ? _buildProfile() : _buildLoginForm(context),
//     );
//   }

//   Widget _buildProfile() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           const CircleAvatar(
//             radius: 50,
//             backgroundImage: AssetImage('assets/user.png'),
//           ),
//           const SizedBox(height: 20),
//           const Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           const Text('john.doe@example.com', style: TextStyle(color: Colors.grey)),
//           const SizedBox(height: 30),
//           ListTile(
//             leading: const Icon(Icons.history, color: Colors.purple),
//             title: const Text('Booking History'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings, color: Colors.purple),
//             title: const Text('Settings'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text('Logout'),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginForm(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'Welcome to SkyFly ✈️',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 30),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(
//               labelText: 'Email',
//               prefixIcon: const Icon(Icons.email),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           TextField(
//             controller: _passwordController,
//             obscureText: true,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               prefixIcon: const Icon(Icons.lock),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           const SizedBox(height: 25),
//           ElevatedButton(
//             onPressed: () {
//               // Add login logic here
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Login functionality to be implemented'),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple[800],
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text('Sign In', style: TextStyle(color: Colors.white)),
//           ),
//           const SizedBox(height: 15),
//           TextButton(
//             onPressed: () {},
//             child: const Text('Create New Account', style: TextStyle(color: Colors.purple)),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Keep ResultsInterface and FlightCheckInterface from previous code (update colors accordingly)