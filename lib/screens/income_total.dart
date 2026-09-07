import 'package:flutter/material.dart';

import 'transaction.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          children: [
            _Header(onBack: () => Navigator.maybePop(context)),
            const SizedBox(height: 20),
            Container(
              constraints: const BoxConstraints(minHeight: 538),
              padding: const EdgeInsets.fromLTRB(18, 21, 18, 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFD8DCE3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _IncomeSummary(),
                  const SizedBox(height: 44),
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      color: Color(0xFF292F3B),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const _IncomeRow(),
                  const SizedBox(height: 255),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TransactionPage(
                            initialFilter: 'Income',
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF214DBD),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      child: const Text(
                        'View All',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Material(
          color: const Color(0xFFF3F7FD),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: const SizedBox(
              width: 38,
              height: 38,
              child: Icon(Icons.arrow_back, color: Color(0xFF2458C6)),
            ),
          ),
        ),
        const SizedBox(width: 13),
        const Text(
          'Income',
          style: TextStyle(
            color: Color(0xFF202634),
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _IncomeSummary extends StatelessWidget {
  const _IncomeSummary();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 31,
          backgroundColor: Color(0xFF12B981),
          child: Text(
            '\$',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Income', style: TextStyle(color: Color(0xFF303746), fontSize: 13)),
            SizedBox(height: 1),
            Text(
              '\$ 1,350.00',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '40% of total expense',
              style: TextStyle(color: Color(0xFF9AA1AE), fontSize: 9),
            ),
          ],
        ),
      ],
    );
  }
}

class _IncomeRow extends StatelessWidget {
  const _IncomeRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Color(0xFF12B981),
          child: Text(
            '\$',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              height: 1,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Salary',
                style: TextStyle(
                  color: Color(0xFF303746),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'August 20, 2026',
                style: TextStyle(color: Color(0xFF9AA1AE), fontSize: 9),
              ),
            ],
          ),
        ),
        Text(
          '+\$1,350.00',
          style: TextStyle(
            color: Color(0xFF222936),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
