
// import 'package:airplane_management/custom_widgets.dart';
// import 'package:flutter/material.dart';
// import 'results_interface.dart';
// import 'flight_check_interface.dart';
// import 'user_profile_interface.dart';
// import '../../widgets/custom_widgets.dart'; // Import the custom widgets

// class MainInterface extends StatelessWidget {
//   final TextEditingController _fromController = TextEditingController();
//   final TextEditingController _toController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();

// ignore_for_file: camel_case_types

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SkyFly ✈️', style: TextStyle(fontWeight: FontWeight.bold)),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 58, 1, 94),
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
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _fromController,
//                 decoration: InputDecoration(labelText: 'From'),
//               ),
//               TextField(
//                 controller: _toController,
//                 decoration: InputDecoration(labelText: 'To'),
//               ),
//               TextField(
//                 controller: _dateController,
//                 decoration: InputDecoration(labelText: 'Date'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ResultsInterface(
//                         from: _fromController.text,
//                         to: _toController.text,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text('Search Flights'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:airplane_management/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'custom_design.dart'; // Make sure the file is in the same folder

class MainInterface extends StatefulWidget {
  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // List of cities for dropdown
  final List<String> cities = ['Mumbai', 'Delhi', 'Bangalore', 'Pune', 'Chennai'];

  // Dropdown selected variables
  String? fromCity;
  String? toCity;

  // Date picker variable
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkyFly ✈️'),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/userProfile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Search Section / Hero Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[800]!, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text(
                      'What flight are you looking for? ✈️',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // From Dropdown
                    DropdownButtonFormField<String>(
                      value: fromCity,
                      hint: const Text('From'),
                      items: cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          fromCity = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // To Dropdown
                    DropdownButtonFormField<String>(
                      value: toCity,
                      hint: const Text('To'),
                      items: cities.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          toCity = value;
                        });
                      },
                    ),

                    const SizedBox(height: 15),

                    // Date Picker
                    InkWell(
                      onTap: () async {
                        DateTime today = DateTime.now();
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: today.add(const Duration(days: 1)),
                          firstDate: today.add(const Duration(days: 1)),
                          lastDate: DateTime(today.year + 25),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'Select Date'
                                  : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Search Button
                    buildSearchButton(
                      context,
                      _fromController,
                      _toController,
                      _dateController,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Featured Flight Deals Carousel
              _buildFeaturedDealsCarousel(context),

              const SizedBox(height: 30),

              // Additional Options Section
              buildAdditionalOptions(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/flightCheck'),
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.airplanemode_active, color: Colors.white),
      ),
    );
  }

  // Featured Deals Carousel
  Widget _buildFeaturedDealsCarousel(BuildContext context) {
    return SizedBox(
      height: 180, // Adjust height
      child: PageView(
        controller: PageController(viewportFraction: 0.9),
        children: [
          _buildDealCard(
            context,
            'Summer Sale!',
            'Up to 30% off on flights to Europe',
            Colors.blueAccent,
          ),
          _buildDealCard(
            context,
            'Weekend Getaway',
            'Enjoy exclusive weekend deals',
            Colors.green,
          ),
          _buildDealCard(
            context,
            'Last Minute Offer',
            'Grab last-minute tickets at a discount',
            Colors.deepOrange,
          ),
        ],
      ),
    );
  }

  // Deal Card Widget
  Widget _buildDealCard(
      BuildContext context, String title, String description, Color bgColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
