import 'dart:developer';

import 'package:airplane_management/bloc/airplane_bloc.dart';
import 'package:airplane_management/bloc/airplane_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'flight_details_page.dart';

class ResultsInterface extends StatelessWidget {
  final String from;
  final String to;

  const ResultsInterface({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AirplaneCubit()..fetchAirplaneData(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flight Results'),
          backgroundColor: Colors.purple[800],
        ),
        body: BlocBuilder<AirplaneCubit, AirplaneState>(
          builder: (context, state) {
            if (state is AirplaneLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AirplaneError) {
              return Center(child: Text(state.errorMessage));
            }
            if (state is AirplaneLoaded) {
              log('From: $from');
              log('To: $to');

              final flights = state.airplaneModel?.data.where((flight) {
                // Convert everything to lowercase and remove special characters
                final fromAirport =
                    flight.departure?.airport?.trim().toLowerCase() ?? '';
                final toAirport =
                    flight.arrival?.airport?.trim().toLowerCase() ?? '';
                final searchFrom = from.split('_').first.trim().toLowerCase();
                final searchTo = to.split('_').first.trim().toLowerCase();

                log('Comparing airports:');
                log('fromAirport: "$fromAirport" vs searchFrom: "$searchFrom"');
                log('toAirport: "$toAirport" vs searchTo: "$searchTo"');

                // Use contains() instead of exact match
                return fromAirport.contains(searchFrom) ||
                    searchFrom.contains(fromAirport) ||
                    flight.departure?.iata?.toLowerCase() ==
                        searchFrom.toLowerCase() ||
                    toAirport.contains(searchTo) ||
                    searchTo.contains(toAirport) ||
                    flight.arrival?.iata?.toLowerCase() ==
                        searchTo.toLowerCase();
              }).toList();

              log('Found ${flights?.length ?? 0} flights');

              if (flights == null || flights.isEmpty) {
                return const Center(
                  child: Text(
                    'No flights found for this route\nPlease try different airports',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: flights.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final flight = flights[index];
                  log(flight.toString());
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${flight.airline?.name}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Flight ${flight.flight?.iata}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildTimeColumn(
                                'Departure',
                                flight.departure?.scheduled,
                                flight.departure?.airport ?? '',
                                flight.departure?.terminal ?? 'N/A',
                              ),
                              const Icon(Icons.flight_takeoff),
                              _buildTimeColumn(
                                'Arrival',
                                flight.arrival?.scheduled,
                                flight.arrival?.airport ?? '',
                                flight.arrival?.terminal ?? 'N/A',
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Status: ${flight.flightStatus?.toUpperCase()}',
                                style: TextStyle(
                                  color: _getStatusColor(flight.flightStatus),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FlightDetailsPage(flight: flight),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[800],
                                ),
                                child: const Text('Select Flight'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildTimeColumn(
    String label,
    DateTime? time,
    String airport,
    String terminal,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time != null
              ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
              : 'N/A',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 120, // Adjust width as needed
          child: Text(
            airport,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
          'Terminal $terminal',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'scheduled':
        return Colors.blue;
      case 'delayed':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
