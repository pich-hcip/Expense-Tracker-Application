import 'package:flutter/material.dart';

import 'login.dart';
import 'register.dart';

class GetStartScreen extends StatelessWidget {
  const GetStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const Color _blue = Color(0xFF0B55C9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF184FC2), Color(0xFF172756)],
            stops: [0, 0.72],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: constraints.maxHeight * 0.21),
                    const _AppLogo(),
                    const SizedBox(height: 28),
                    const Text(
                      'Expense Tracker',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Track your income and\nexpense easily',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFE2E8F8),
                        fontSize: 12,
                        height: 1.12,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const RegisterScreen(),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.white,
                          foregroundColor: _blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 54),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginScreen(),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text.rich(
                          TextSpan(
                            text: 'Already have an account? ',
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            color: Color(0xFFD9E1F5),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: constraints.maxHeight * 0.09),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: SizedBox(
          width: 43,
          height: 38,
          child: CustomPaint(painter: _WalletLogoPainter()),
        ),
      ),
    );
  }
}

class _WalletLogoPainter extends CustomPainter {
  const _WalletLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const blue = OnboardingScreen._blue;
    final fill = Paint()
      ..color = blue
      ..style = PaintingStyle.fill;
    final line = Paint()
      ..color = blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // The two cards/notes peeking out from the top of the wallet.
    final backCard = Path()
      ..moveTo(size.width * .25, size.height * .30)
      ..lineTo(size.width * .44, size.height * .07)
      ..quadraticBezierTo(
        size.width * .48,
        size.height * .02,
        size.width * .55,
        size.height * .05,
      )
      ..lineTo(size.width * .74, size.height * .22);
    canvas.drawPath(backCard, line);

    final frontCard = Path()
      ..moveTo(size.width * .42, size.height * .28)
      ..lineTo(size.width * .59, size.height * .11)
      ..quadraticBezierTo(
        size.width * .63,
        size.height * .07,
        size.width * .68,
        size.height * .10,
      )
      ..lineTo(size.width * .82, size.height * .25);
    canvas.drawPath(frontCard, line);

    // Main wallet body.
    final wallet = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .08,
        size.height * .28,
        size.width * .84,
        size.height * .66,
      ),
      Radius.circular(size.width * .13),
    );
    canvas.drawRRect(wallet, fill);

    // White clasp detail on the front of the wallet.
    final claspPaint = Paint()..color = Colors.white;
    final clasp = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * .58,
        size.height * .56,
        size.width * .27,
        size.height * .16,
      ),
      Radius.circular(size.width * .045),
    );
    canvas.drawRRect(clasp, claspPaint);
    canvas.drawCircle(
      Offset(size.width * .74, size.height * .64),
      size.width * .022,
      fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
