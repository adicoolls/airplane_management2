// e_ticket_interface.dart
import 'package:flutter/material.dart';

class ETicketInterface extends StatelessWidget {
  // Accept ticket information via a Map
  final Map<String, String> ticketData;

  const ETicketInterface({super.key, required this.ticketData});

  @override
  Widget build(BuildContext context) {
    // You can customize the UI further as needed.
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Ticket'),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title section with flight name/number
            Text(
              'E-Ticket for ${ticketData['flight'] ?? 'Flight'}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Ticket Information Card 1: Route
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading:
                    const Icon(Icons.flight_takeoff, color: Colors.redAccent),
                title: Text('From: ${ticketData['from'] ?? 'Unknown'}'),
                subtitle: Text('To: ${ticketData['to'] ?? 'Unknown'}'),
              ),
            ),
            const SizedBox(height: 10),
            // Ticket Information Card 2: Timing Details
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(Icons.access_time, color: Colors.redAccent),
                title: Text('Departure: ${ticketData['departure'] ?? 'TBD'}'),
                subtitle: Text('Arrival: ${ticketData['arrival'] ?? 'TBD'}'),
              ),
            ),
            const SizedBox(height: 10),
            // Additional Ticket Details (e.g., seat, gate)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(Icons.event_seat, color: Colors.redAccent),
                title: Text('Seat: ${ticketData['seat'] ?? 'Not Assigned'}'),
                subtitle: Text('Gate: ${ticketData['gate'] ?? 'TBD'}'),
              ),
            ),
            const SizedBox(height: 20),
            // A simple notice or extra instructions
            Text(
              'Please arrive at the boarding gate at least 30 minutes before departure.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
