import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'; // needed for TapGestureRecognizer (tappable "Register" text)

// ===============================================
// LOGIN SCREEN - Easy to understand Flutter code
// ===============================================
// This file shows a simple login page like the design:
// - Welcome text
// - Email field
// - Password field (with show/hide icon)
// - Forgot password link
// - Login button
// - Register text at the bottom

void main() {
  runApp(const login());
}

class login extends StatelessWidget {
  const login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hide the "DEBUG" banner
      home: const LoginScreen(),
    );
  }
}

// StatefulWidget = a widget that can change (example: show/hide password)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // This variable controls if the password is hidden or shown
  bool _isPasswordHidden = true;

  // Controllers let us read what the user typed
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        // SafeArea keeps content away from the phone notch/status bar
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            // Lets the screen scroll if the keyboard covers the fields
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // ---------- Title ----------
                const Text(
                  'Welcome Back! 👋',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 30),

                // ---------- Email Field ----------
                _buildEmailField(),

                const SizedBox(height: 16),

                // ---------- Password Field ----------
                _buildPasswordField(),

                const SizedBox(height: 10),

                // ---------- Forgot Password ----------
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: go to forgot password screen
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),

                const SizedBox(height: 200), // empty space, like in the design

                // ---------- Login Button ----------
                _buildLoginButton(),

                const SizedBox(height: 30),

                // ---------- Register Text ----------
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black54, fontSize: 14),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Register',
                          style: const TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                          // Makes "Register" tappable
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: go to register screen
                            },
                        ),
                      ],
                    ),
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

  // ---------------------------------------------
  // Small reusable functions below (easy to read)
  // ---------------------------------------------

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        prefixIcon: const Icon(Icons.email_outlined),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none, // no border line, just background color
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: _isPasswordHidden, // true = hide password with dots
      decoration: InputDecoration(
        hintText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
        // The eye icon that shows/hides the password
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: () {
            setState(() {
              // Flip true <-> false, then rebuild the screen
              _isPasswordHidden = !_isPasswordHidden;
            });
          },
        ),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity, // full width button
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // Read what the user typed
          final email = _emailController.text;
          final password = _passwordController.text;

          // TODO: put your login logic here (call API, check fields, etc.)
          print('Email: $email, Password: $password');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}