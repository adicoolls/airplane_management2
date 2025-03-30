
import 'package:airplane_management/e_ticket_interface.dart';
import 'package:flutter/material.dart';
import 'e_ticket_interface.dart';

class ResultsInterface extends StatelessWidget {
  final String from;
  final String to;

  ResultsInterface({required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    final List<String> flightNames = [
      'Flight A123',
      'Flight B456',
      'Flight C789',
      'Flight D012',
      'Flight E345'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Results'),
      ),
      body: ListView.builder(
        itemCount: flightNames.length,
        itemBuilder: (context, index) {
          final departureTime = TimeOfDay(hour: 10 + (index * 2), minute: 0);
          final price = 200 + (index * 20);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: const Icon(Icons.flight, color: Colors.redAccent),
              title: Text(flightNames[index]),
              subtitle: Text('Departure: ${departureTime.format(context)} | Price: \$$price'),
              trailing: const Icon(Icons.arrow_forward, color: Colors.purple),
              onTap: () {
                // Create a sample ticket data map.
                // In a real app, you might fetch these details from an API or the selected flight object.
                final ticketData = {
                  'flight': flightNames[index],
                  'from': from,
                  'to': to,
                  'departure': departureTime.format(context),
                  'arrival': '1:00 PM', // Example arrival time
                  'seat': '12A', // Example seat assignment
                  'gate': 'B3', // Example gate
                };

                // Navigate to the E-Ticket interface
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ETicketInterface(ticketData: ticketData),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}