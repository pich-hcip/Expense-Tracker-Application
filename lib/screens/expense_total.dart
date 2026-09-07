import 'package:flutter/material.dart';

import 'transaction.dart';

class ExpenseTotalScreen extends StatelessWidget {
  const ExpenseTotalScreen({super.key});

  static const _transactions = [
    _ExpenseItem('Lunch', 'August 20, 2026', '-\$13.25', Icons.restaurant, Color(0xFFFF7618)),
    _ExpenseItem('Coffee', 'August 20, 2026', '-\$13.25', Icons.coffee, Color(0xFF21B58A)),
    _ExpenseItem('Dinner', 'August 20, 2026', '-\$13.25', Icons.restaurant, Color(0xFFF0445E)),
    _ExpenseItem('Shopping', 'August 20, 2026', '-\$13.25', Icons.shopping_bag, Color(0xFFD80B73)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                children: [
                  _Header(onBack: () => Navigator.maybePop(context)),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFD9DDE4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _ExpenseSummary(),
                        const SizedBox(height: 30),
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            color: Color(0xFF303746),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 9),
                        for (final transaction in _transactions)
                          _ExpenseRow(item: transaction),
                        const SizedBox(height: 53),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const TransactionPage(
                                  initialFilter: 'Expense',
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
        const SizedBox(width: 12),
        const Text(
          'Expense',
          style: TextStyle(
            color: Color(0xFF202634),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ExpenseSummary extends StatelessWidget {
  const _ExpenseSummary();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 29,
          backgroundColor: Color(0xFFFF7618),
          child: Icon(Icons.restaurant, color: Colors.white, size: 29),
        ),
        SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Expense',
              style: TextStyle(color: Color(0xFF303746), fontSize: 12),
            ),
            SizedBox(height: 1),
            Text(
              '\$730.50',
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3),
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

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.item});

  final _ExpenseItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: item.color,
            child: Icon(item.icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF303746),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.date,
                  style: const TextStyle(color: Color(0xFF9AA1AE), fontSize: 9),
                ),
              ],
            ),
          ),
          Text(
            item.amount,
            style: const TextStyle(
              color: Color(0xFF222936),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseItem {
  const _ExpenseItem(this.title, this.date, this.amount, this.icon, this.color);

  final String title;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;
}
