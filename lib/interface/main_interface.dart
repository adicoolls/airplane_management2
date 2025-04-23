import 'package:airplane_management/bloc/airplane_bloc.dart';
import 'package:airplane_management/bloc/airplane_state.dart';
import 'package:airplane_management/custom_widgets.dart';
import 'package:airplane_management/models/airplane_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainInterface extends StatefulWidget {
  const MainInterface({super.key});

  @override
  State<MainInterface> createState() => _MainInterfaceState();
}

class _MainInterfaceState extends State<MainInterface> {
  // final TextEditingController _fromController = TextEditingController();
  // final TextEditingController _toController = TextEditingController();
  // final TextEditingController _dateController = TextEditingController();

  // Dropdown selected variables
  String? fromCity;
  String? toCity;

  // Date picker variable
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AirplaneCubit()..fetchAirplaneData(),
      child: Scaffold(
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
                BlocBuilder<AirplaneCubit, AirplaneState>(
                  builder: (context, state) {
                    if (state is AirplaneLoading) {
                      return CircularProgressIndicator.adaptive();
                    }
                    if (state is AirplaneLoaded) {
                      final AirplaneModel? airplaneModel = state.airplaneModel;

                      // Create sets to store unique airports
                      final Set<String> uniqueDepartures = {};
                      final Set<String> uniqueArrivals = {};

                      // Create departure and arrival items first
                      final departureItems =
                          airplaneModel?.data.where((airport) {
                                final airportCode =
                                    "${airport.departure?.airport}_${airport.departure?.iata}";
                                return uniqueDepartures.add(airportCode);
                              }).map((airport) {
                                final airportCode =
                                    "${airport.departure?.airport}_${airport.departure?.iata}";
                                return DropdownMenuItem(
                                  value: airportCode,
                                  child: Text(
                                    "${airport.departure?.airport} (${airport.departure?.iata})",
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList() ??
                              [];

                      final arrivalItems = airplaneModel?.data.where((airport) {
                            final airportCode =
                                "${airport.arrival?.airport}_${airport.arrival?.iata}";
                            return uniqueArrivals.add(airportCode);
                          }).map((airport) {
                            final airportCode =
                                "${airport.arrival?.airport}_${airport.arrival?.iata}";
                            return DropdownMenuItem(
                              value: airportCode,
                              child: Text(
                                "${airport.arrival?.airport} (${airport.arrival?.iata})",
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList() ??
                          [];

                      // Check if current values exist in the new items
                      if (fromCity != null &&
                          !uniqueDepartures.contains(fromCity)) {
                        fromCity = null;
                      }
                      if (toCity != null && !uniqueArrivals.contains(toCity)) {
                        toCity = null;
                      }

                      return Container(
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
                              isExpanded: true,
                              items: departureItems,
                              onChanged: (value) {
                                setState(() {
                                  fromCity = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // To Dropdown
                            DropdownButtonFormField<String>(
                              value: toCity,
                              hint: const Text('To'),
                              isExpanded: true,
                              items: arrivalItems,
                              onChanged: (value) {
                                setState(() {
                                  toCity = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                              ),
                            ),

                            const SizedBox(height: 15),

                            // Date Picker
                            InkWell(
                              onTap: () async {
                                DateTime today = DateTime.now();
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      today.add(const Duration(days: 1)),
                                  firstDate: today.add(const Duration(days: 1)),
                                  lastDate: DateTime(today.year + 25),
                                );
                                setState(() {
                                  selectedDate = pickedDate;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              fromCity.toString(),
                              toCity.toString(),
                              selectedDate.toString(),
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is AirplaneError) {
                      return Center(
                        child: Text(state.errorMessage.toString()),
                      );
                    }
                    return SizedBox();
                  },
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
