import 'package:airplane_management/core/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/booking_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/auth_services.dart';
import 'main_interface.dart';

class UserProfileInterface extends StatefulWidget {
  const UserProfileInterface({super.key});

  @override
  _UserProfileInterfaceState createState() => _UserProfileInterfaceState();
}

class _UserProfileInterfaceState extends State<UserProfileInterface> {
  final AuthService _authService = AuthService();

  // For demo purposes, we'll start with the user not logged in.
  bool isLoggedIn = false;
  // Toggle between login and sign-up modes.
  bool _isLoginMode = true;

  // Controllers for login/sign-up form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text(
              'User Profile',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.purple[800],
            actions: snapshot.hasData
                ? [
                    // Only show logout button when user is logged in
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await _authService.signOut();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      tooltip: 'Logout',
                    ),
                  ]
                : null,
          ),
          body: snapshot.hasData ? _buildProfile() : _buildAuthForm(),
        );
      },
    );
  }

  // Profile view for logged in users remains the same.
  Widget _buildProfile() {
    final user = FirebaseAuth.instance.currentUser;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(AppImages.userProfile),
          ),
          const SizedBox(height: 20),
          Text(user?.displayName ?? 'User',
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(user?.email ?? '', style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Booking History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildBookingHistory(),
        ],
      ),
    );
  }

  // Authentication form with a toggle between Login and Sign-Up
  Widget _buildAuthForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isLoginMode ? 'Welcome to SkyFly ✈️' : 'Create an Account',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // If in sign-up mode, show the name field.
            if (!_isLoginMode)
              Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            // In sign-up mode, add a confirm password field.
            if (!_isLoginMode)
              Column(
                children: [
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ElevatedButton(
              onPressed: _handleAuthentication,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[800],
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                _isLoginMode ? 'Sign In' : 'Sign Up',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            // Toggle between login and sign-up forms.
            TextButton(
              onPressed: () {
                setState(() {
                  _isLoginMode = !_isLoginMode;
                });
              },
              child: Text(
                _isLoginMode
                    ? 'Don\'t have an account? Sign Up'
                    : 'Already have an account? Sign In',
                style: const TextStyle(color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleAuthentication() async {
    try {
      if (_isLoginMode) {
        // Handle login
        await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
      } else {
        // Handle registration
        if (_passwordController.text != _confirmPasswordController.text) {
          throw 'Passwords do not match!';
        }
        await _authService.registerWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      // Clear form fields
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _nameController.clear();

      // Navigate to MainInterface after successful authentication
      if (mounted && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainInterface(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Widget _buildBookingHistory() {
    final bookingService = BookingService();

    return StreamBuilder<QuerySnapshot>(
      stream: bookingService.getBookingHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No booking history available'),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final booking =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;
            final timestamp = booking['date'] as Timestamp?;
            final date = timestamp?.toDate();

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  '${booking['airline']} - ${booking['flightNumber']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${booking['from']} → ${booking['to']}'),
                    Text(
                      'Date: ${date?.toString().split(' ')[0] ?? 'N/A'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking['status']?.toString().toUpperCase() ?? 'N/A',
                    style: TextStyle(
                      color: Colors.purple[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
