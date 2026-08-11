import 'package:flutter/material.dart';


// ===================================================
// ONBOARDING SCREEN - Easy to understand Flutter code
// ===================================================
// This screen shows:
// - A blue background
// - A white box (logo placeholder) at the top
// - App title "Expense Tracker"
// - A short description
// - A white "Get Started" button
// - "Already have an account? Login" text at the bottom

// void main() {
//   runApp(const MyApp());
// }

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hides the "DEBUG" banner
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Colors used in the design, kept in one place so they are easy to change
  static const Color backgroundBlue = Color(0xFF0D47B4);
  static const Color buttonTextPurple = Color(0xFF6A1B9A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // ---------- Logo placeholder (white box) ----------
              _buildLogoBox(),

              const SizedBox(height: 40),

              // ---------- Title ----------
              const Text(
                'Expense Tracker',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // ---------- Subtitle ----------
              const Text(
                'Track your income and expense easily',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70, // slightly transparent white
                ),
              ),

              // Spacer pushes everything below it to the bottom of the screen
              const Spacer(),

              // ---------- Get Started Button ----------
              _buildGetStartedButton(context),

              const SizedBox(height: 20),

              // ---------- Already have an account? Login ----------
              _buildLoginText(context),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------
  // Small reusable functions below (easy to read)
  // ---------------------------------------------

  Widget _buildLogoBox() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      // Put your app logo image here, for example:
      // child: Image.asset('assets/logo.png'),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity, // full width button
      height: 55,
      child: ElevatedButton(
        onPressed: () {
          // TODO: go to your Sign Up / Home screen
          // Example:
          // Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: buttonTextPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: go to your Login screen
        // Example:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      },
      child: RichText(
        text: const TextSpan(
          style: TextStyle(color: Colors.white70, fontSize: 14),
          children: [
            TextSpan(text: "Already have an account? "),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}