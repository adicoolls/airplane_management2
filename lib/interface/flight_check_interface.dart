import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:airplane_management/bloc/airplane_bloc.dart';
import 'package:airplane_management/bloc/airplane_state.dart';
import 'package:airplane_management/models/airplane_model.dart';

class FlightCheckInterface extends StatelessWidget {
  FlightCheckInterface({super.key});

  final TextEditingController _flightNumberController = TextEditingController();

  void _showFlightDetails(BuildContext context, Datum flight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),

                // Flight Header
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple[800]!, Colors.purple[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple[200]!,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Flight ${flight.flight?.iata}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          flight.flightStatus?.toUpperCase() ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Flight Info Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildInfoCard(
                        'Departure',
                        flight.departure?.airport ?? 'N/A',
                        Icons.flight_takeoff,
                        [
                          _buildDetailRow(
                              'Terminal', flight.departure?.terminal ?? 'N/A'),
                          _buildDetailRow(
                              'Gate', flight.departure?.gate ?? 'N/A'),
                          if (flight.departure?.scheduled != null)
                            _buildDetailRow(
                              'Time',
                              '${flight.departure!.scheduled!.hour.toString().padLeft(2, '0')}:${flight.departure!.scheduled!.minute.toString().padLeft(2, '0')}',
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Arrival',
                        flight.arrival?.airport ?? 'N/A',
                        Icons.flight_land,
                        [
                          _buildDetailRow(
                              'Terminal', flight.arrival?.terminal ?? 'N/A'),
                          _buildDetailRow(
                              'Gate', flight.arrival?.gate ?? 'N/A'),
                          if (flight.arrival?.scheduled != null)
                            _buildDetailRow(
                              'Time',
                              '${flight.arrival!.scheduled!.hour.toString().padLeft(2, '0')}:${flight.arrival!.scheduled!.minute.toString().padLeft(2, '0')}',
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildInfoCard(
                        'Flight Details',
                        flight.airline?.name ?? 'N/A',
                        Icons.airplane_ticket,
                        [
                          _buildDetailRow(
                              'Aircraft', flight.aircraft?.iata ?? 'N/A'),
                          _buildDetailRow(
                            'Delay',
                            flight.departure?.delay != null
                                ? '${flight.departure?.delay} minutes'
                                : 'No delay',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String subtitle, IconData icon, List<Widget> details) {
    return Card(
      elevation: 4,
      shadowColor: Colors.purple[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.purple[800], size: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            ...details,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AirplaneCubit()..fetchAirplaneData(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Flight Status'),
          backgroundColor: Colors.purple[800],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.purple[800],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Check Your Flight Status',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _flightNumberController,
                        decoration: InputDecoration(
                          hintText: 'Enter Flight Number (e.g., AA1234)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon:
                              Icon(Icons.flight, color: Colors.purple[800]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        style: const TextStyle(fontSize: 16),
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<AirplaneCubit, AirplaneState>(
                  builder: (context, state) {
                    if (state is AirplaneLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is AirplaneLoaded) {
                      final flights = state.airplaneModel?.data;
                      // log('flights $flights');
                      return ElevatedButton(
                        onPressed: () {
                          final flightNumber =
                              _flightNumberController.text.trim();
                          if (flightNumber.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a flight number'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          log('flightNumber $flightNumber');

                          final flight = flights?.firstWhere(
                            (f) {
                              log('data number : ${f.flight?.number}');
                              return f.flight?.number ==
                                  flightNumber.toLowerCase();
                            },
                            orElse: () => Datum(
                              live: null,
                              flightDate: null,
                              flightStatus: null,
                              departure: null,
                              arrival: null,
                              airline: null,
                              flight: null,
                              aircraft: null,
                            ),
                          );

                          log(flight?.flight?.number ?? '');

                          if (flight != null && flight.flight?.number != null) {
                            _showFlightDetails(context, flight);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Flight not found'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[800],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Search Flight',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                    if (state is AirplaneError) {
                      return Center(child: Text(state.errorMessage));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
