import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BudgetNotificationScreen extends StatelessWidget {
  const BudgetNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF3E82ED),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _BudgetHeader(onClose: () => Navigator.maybePop(context)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 17),
                  padding: const EdgeInsets.fromLTRB(34, 31, 34, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                  ),
                  child: Column(
                    children: [
                      const _AlertIcon(),
                      const SizedBox(height: 19),
                      const Text(
                        "You’re over budget",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF111111),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "You’ve spend \$1,205.00 for your \$1,120.00\nmonthly budget \$85.00 over, with 6 days\nleft.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF777777),
                          fontSize: 11,
                          height: 1.3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const _SpendingCard(),
                      const SizedBox(height: 19),
                      const _InsightCard(),
                      const Spacer(),
                      _ActionButton(
                        label: 'View Transactions',
                        filled: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 14),
                      _ActionButton(
                        label: 'Adjust Budget',
                        onPressed: () {},
                      ),
                      const Spacer(),
                      const _HomeIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetHeader extends StatelessWidget {
  const _BudgetHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: IconButton(
              tooltip: 'Close',
              onPressed: onClose,
              icon: const Icon(Icons.close, color: Colors.white, size: 23),
            ),
          ),
          const Expanded(
            child: Text(
              'Budget Alert',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 70),
        ],
      ),
    );
  }
}

class _AlertIcon extends StatelessWidget {
  const _AlertIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: const BoxDecoration(
        color: Color(0xFFFFE6E8),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.report_gmailerrorred_rounded,
        color: Color(0xFFE5222D),
        size: 38,
      ),
    );
  }
}

class _SpendingCard extends StatelessWidget {
  const _SpendingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 13),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9DDDA)),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Text('Spent', style: TextStyle(color: Color(0xFF777777), fontSize: 11)),
              Spacer(),
              Text(
                '\$1,205.00',
                style: TextStyle(
                  color: Color(0xFFE2484F),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const LinearProgressIndicator(
              value: 1,
              minHeight: 8,
              color: Color(0xFFD94E55),
              backgroundColor: Color(0xFFF0D9DA),
            ),
          ),
          const SizedBox(height: 7),
          const Row(
            children: [
              Text(
                '\$85.00 over limit',
                style: TextStyle(color: Color(0xFFE2484F), fontSize: 10),
              ),
              Spacer(),
              Text(
                'Limit: \$1,120.00',
                style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9DDDA)),
      ),
      child: const Row(
        children: [
          Icon(Icons.trending_up_rounded, color: Color(0xFFFF5860), size: 24),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "Transport pushed you over —\nit’s \$30.00 above it’s usual\nspend this month",
              style: TextStyle(
                color: Color(0xFFB3262E),
                fontSize: 12,
                height: 1.25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: filled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF173174),
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: const Color(0x552A5BDB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF858585),
                side: const BorderSide(color: Color(0xFF2575E7)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 4,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF171313),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
