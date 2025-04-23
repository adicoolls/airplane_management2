// import 'package:flutter/material.dart';

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
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FlightCheckInterface extends StatefulWidget {
  @override
  _FlightCheckInterfaceState createState() => _FlightCheckInterfaceState();
}

class _FlightCheckInterfaceState extends State<FlightCheckInterface> {
  final List<String> _airports = ['KWM', 'CNS', 'SYD', 'MEL']; // Add your IATA codes
  String? _selectedDeparture;
  String? _selectedArrival;
  DateTime? _selectedDate;
  bool _isLoading = false;
  Map<String, dynamic>? _flightData;

  Future<void> _fetchFlightData() async {
    if (_selectedDeparture == null || _selectedArrival == null || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all fields!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          'https://api.aviationstack.com/v1/flights?access_key=61f50e151083003b80a3ceba346bed78'
          '&dep_iata=$_selectedDeparture'
          '&arr_iata=$_selectedArrival'
          '&flight_date=${_selectedDate!.toIso8601String().split('T')[0]}', // Format: YYYY-MM-DD
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          setState(() => _flightData = data['data'][0]);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No flights found!')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Status ✈️'),
        backgroundColor: Colors.purple[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Departure Dropdown
            DropdownButtonFormField<String>(
              value: _selectedDeparture,
              decoration: InputDecoration(
                labelText: 'Departure Airport (IATA)',
                prefixIcon: Icon(Icons.flight_takeoff, color: Colors.redAccent),
                border: OutlineInputBorder(),
              ),
              items: _airports
                  .map((airport) => DropdownMenuItem(
                        value: airport,
                        child: Text(airport),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedDeparture = value),
            ),
            SizedBox(height: 20),
            // Arrival Dropdown
            DropdownButtonFormField<String>(
              value: _selectedArrival,
              decoration: InputDecoration(
                labelText: 'Arrival Airport (IATA)',
                prefixIcon: Icon(Icons.flight_land, color: Colors.redAccent),
                border: OutlineInputBorder(),
              ),
              items: _airports
                  .map((airport) => DropdownMenuItem(
                        value: airport,
                        child: Text(airport),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedArrival = value),
            ),
            SizedBox(height: 20),
            // Date Picker
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Flight Date',
                prefixIcon: Icon(Icons.calendar_today, color: Colors.redAccent),
                border: OutlineInputBorder(),
                hintText: _selectedDate == null 
                    ? 'Select Date' 
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchFlightData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Search Flights', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            if (_flightData != null) _buildFlightDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightDetails() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Flight Status: ${_flightData!['flight_status']?.toUpperCase() ?? 'N/A'}', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.purple)),
            SizedBox(height: 12),
            _buildDetailRow('Departure', 
                '${_flightData!['departure']['airport']} (${_flightData!['departure']['iata']})'),
            _buildDetailRow('Scheduled', 
                '${_flightData!['departure']['scheduled']?.split('T')[1].substring(0, 5) ?? 'N/A'}'),
            _buildDetailRow('Arrival', 
                '${_flightData!['arrival']['airport']} (${_flightData!['arrival']['iata']})'),
            _buildDetailRow('Actual Landing', 
                '${_flightData!['arrival']['actual']?.split('T')[1].substring(0, 5) ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }
}