import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WalletNotificationScreen extends StatelessWidget {
  const WalletNotificationScreen({super.key});

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
              _WalletHeader(onBack: () => Navigator.maybePop(context)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 17),
                  padding: const EdgeInsets.fromLTRB(22, 21, 22, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(31),
                  ),
                  child: Column(
                    children: [
                      const _WalletIcon(),
                      const SizedBox(height: 14),
                      const Text(
                        'Your wallet is running low',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF17214A),
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 9),
                      const Text(
                        'Cash balance is down to \$18.50. You may want to top\nup soon.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8290A7),
                          fontSize: 9,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 27),
                      const _BalanceCard(),
                      const SizedBox(height: 25),
                      const _WarningCard(),
                      const Spacer(),
                      _WalletButton(
                        label: '+  Add Income to Cash',
                        filled: true,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 14),
                      _WalletButton(label: 'View Wallet', onPressed: () {}),
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

class _WalletHeader extends StatelessWidget {
  const _WalletHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 59,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 58,
            child: IconButton(
              tooltip: 'Back',
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Wallet Alert',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 58),
        ],
      ),
    );
  }
}

class _WalletIcon extends StatelessWidget {
  const _WalletIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 47,
      decoration: const BoxDecoration(
        color: Color(0xFF10B981),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.account_balance_wallet_outlined,
        color: Colors.white,
        size: 27,
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(21, 13, 15, 11),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(
                Icons.payments_outlined,
                color: Color(0xFF12C88A),
                size: 16,
              ),
              SizedBox(width: 17),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cash',
                    style: TextStyle(
                      color: Color(0xFF20294A),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Cash in Hand',
                    style: TextStyle(color: Color(0xFF8E98A9), fontSize: 8),
                  ),
                ],
              ),
              Spacer(),
              Text(
                '\$18.50',
                style: TextStyle(
                  color: Color(0xFFFF6B1A),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: .15,
              minHeight: 6,
              color: Color(0xFF7B5A16),
              backgroundColor: Color(0xFFD7D7D7),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 10, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF4),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFF6C58C)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFF5A623), size: 16),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              'At your current spending pace,\nthis wallet may run out in 2\ndays.',
              style: TextStyle(
                color: Color(0xFF8A6318),
                fontSize: 10,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletButton extends StatelessWidget {
  const _WalletButton({
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
      height: 43,
      child: filled
          ? ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF182E6D),
                foregroundColor: Colors.white,
                elevation: 5,
                shadowColor: const Color(0x552A5BDB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF858585),
                side: const BorderSide(color: Color(0xFF2575E7)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 4,
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF171313),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
