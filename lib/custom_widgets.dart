import 'dart:developer';

import 'package:flutter/material.dart';

Widget buildInputField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    style: const TextStyle(color: Colors.white),
  );
}

Widget buildDatePicker(BuildContext context, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: 'Date',
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    style: const TextStyle(color: Colors.white),
    onTap: () async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
      );
      if (pickedDate != null) {
        controller.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      }
    },
  );
}

Widget buildSearchButton(
    BuildContext context, String from, String to, String date) {
  return ElevatedButton(
    onPressed: () {
      if (from != "null" && to != "null") {
        // Check if values are selected
        Navigator.pushNamed(
          context,
          '/results',
          arguments: {
            'fromCity':
                from.split('_')[0], // Get airport name without IATA code
            'toCity': to.split('_')[0], // Get airport name without IATA code
          },
        );
      } else {
        // Show error message if no cities are selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select both departure and arrival cities'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.redAccent,
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: const Text(
      'Search Flights',
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  );
}

Widget buildAdditionalOptions() {
  return Column(
    children: [
      const Text(
        'Popular Destinations 🌍',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 15),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildDestinationCard('Mumbai', 'in'),
            _buildDestinationCard('Delhi', 'dh'),
            _buildDestinationCard('Pune', 'mh'),
          ],
        ),
      ),
      const SizedBox(height: 25),
      const Text(
        'Special Offers 🔥',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 15),
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_offer, color: Colors.redAccent),
            const SizedBox(width: 10),
            const Text('Get 20% OFF on first booking!'),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: const Text('CLAIM NOW',
                  style: TextStyle(color: Colors.purple)),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildDestinationCard(String city, String flag) {
  return Container(
    margin: const EdgeInsets.only(right: 15),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Row(
      children: [
        Text(flag, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Text(city, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}
