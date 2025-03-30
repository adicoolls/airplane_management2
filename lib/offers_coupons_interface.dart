// offers_coupons_interface.dart
import 'package:flutter/material.dart';

class OffersCouponsInterface extends StatefulWidget {
  @override
  _OffersCouponsInterfaceState createState() => _OffersCouponsInterfaceState();
}

class _OffersCouponsInterfaceState extends State<OffersCouponsInterface>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller with a 1-second duration.
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    // Define a simple fade-in animation.
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController!);

    // Start the animation.
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  // Helper method to build an offer card.
  Widget _buildOfferCard(String title, String description, String code) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const Icon(Icons.local_offer, color: Colors.redAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(code,
              style: TextStyle(
                  color: Colors.purple[800], fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers & Coupons'),
        centerTitle: true,
        backgroundColor: Colors.purple[800],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation!,
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildOfferCard('Summer Sale', 'Get 30% off on your next booking', 'SUMMER30'),
            _buildOfferCard('New User', 'Sign up and get a 20% discount', 'WELCOME20'),
            _buildOfferCard('Weekend Special', 'Exclusive deals for weekend trips', 'WEEKEND50'),
            // You can add more offer cards as needed.
          ],
        ),
      ),
    );
  }
}
