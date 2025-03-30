// import 'package:flutter/material.dart';

// class UserProfileInterface extends StatelessWidget {
//   final bool isLoggedIn = false; // Change this to manage login state
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         backgroundColor: Colors.purple[800],
//       ),
//       body: isLoggedIn ? _buildProfile() : _buildLoginForm(context),
//     );
//   }

//   Widget _buildProfile() {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           const CircleAvatar(
//             radius: 50,
//             backgroundImage: AssetImage('assets/user.png'),
//           ),
//           const SizedBox(height: 20),
//           const Text('John Doe', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 10),
//           const Text('john.doe@example.com', style: TextStyle(color: Colors.grey)),
//           const SizedBox(height: 30),
//           ListTile(
//             leading: const Icon(Icons.history, color: Colors.purple),
//             title: const Text('Booking History'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.settings, color: Colors.purple),
//             title: const Text('Settings'),
//             onTap: () {},
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text('Logout'),
//             onTap: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoginForm(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Text(
//             'Welcome to SkyFly ✈️',
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 30),
//           TextField(
//             controller: _emailController,
//             decoration: InputDecoration(
//               labelText: 'Email',
//               prefixIcon: const Icon(Icons.email),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           TextField(
//             controller: _passwordController,
//             obscureText: true,
//             decoration: InputDecoration(
//               labelText: 'Password',
//               prefixIcon: const Icon(Icons.lock),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           const SizedBox(height: 25),
//           ElevatedButton(
//             onPressed: () {
//               // Add login logic here
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Login functionality to be implemented'),
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.purple[800],
//               padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             child: const Text('Sign In', style: TextStyle(color: Colors.white)),
//           ),
//           const SizedBox(height: 15),
//           TextButton(
//             onPressed: () {},
//             child: const Text('Create New Account', style: TextStyle(color: Colors.purple)),
//           ),
//         ],
//       ),
//     );
//   }
// }
// user_profile_interface.dart

import 'package:flutter/material.dart';

class UserProfileInterface extends StatefulWidget {
  @override
  _UserProfileInterfaceState createState() => _UserProfileInterfaceState();
}

class _UserProfileInterfaceState extends State<UserProfileInterface> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.purple[800],
      ),
      body: isLoggedIn ? _buildProfile() : _buildAuthForm(),
    );
  }

  // Profile view for logged in users remains the same.
  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/user.png'),
          ),
          const SizedBox(height: 20),
          const Text('John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('john.doe@example.com',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 30),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.purple),
            title: const Text('Booking History'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.purple),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () {},
          ),
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
              onPressed: () {
                if (_isLoginMode) {
                  // Add login logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Login functionality to be implemented'),
                    ),
                  );
                } else {
                  // Basic validation for sign-up (you can expand this)
                  if (_nameController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty ||
                      _confirmPasswordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }
                  if (_passwordController.text != _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Passwords do not match!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }
                  // Add sign-up logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sign-Up functionality to be implemented'),
                    ),
                  );
                }
              },
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
}
