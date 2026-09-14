import 'package:flutter/material.dart';

const transactionSections = [
  TransactionSection('Today', [
    TransactionRecord(
      title: 'Lunch',
      category: 'Food',
      amount: '-\$13.50',
      date: 'August 20, 2026',
      icon: Icons.restaurant_rounded,
      color: Color(0xFFFF7618),
    ),
    TransactionRecord(
      title: 'Salary',
      category: 'Income',
      amount: '+\$1,350.00',
      date: 'August 20, 2026',
      icon: Icons.attach_money_rounded,
      color: Color(0xFF16B98B),
      income: true,
    ),
    TransactionRecord(
      title: 'Coffee',
      category: 'Food',
      amount: '-\$13.50',
      date: 'August 20, 2026',
      icon: Icons.coffee_rounded,
      color: Color(0xFFFF7618),
    ),
  ]),
  TransactionSection('Yesterday', [
    TransactionRecord(
      title: 'Taxi',
      category: 'Food',
      amount: '-\$13.50',
      date: 'August 20, 2026',
      icon: Icons.local_taxi_rounded,
      color: Color(0xFFFF7618),
    ),
    TransactionRecord(
      title: 'Electricity Bill',
      category: 'Food',
      amount: '-\$50.50',
      date: 'August 20, 2026',
      icon: Icons.lightbulb_rounded,
      color: Color(0xFFFF7618),
    ),
  ]),
  TransactionSection('August 25, 2026', [
    TransactionRecord(
      title: 'Clothes',
      category: 'Food',
      amount: '-\$13.50',
      date: 'August 20, 2026',
      icon: Icons.checkroom_rounded,
      color: Color(0xFFFF7618),
    ),
  ]),
];

class TransactionSection {
  const TransactionSection(this.label, this.items);

  final String label;
  final List<TransactionRecord> items;
}

class TransactionRecord {
  const TransactionRecord({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
    this.income = false,
  });

  final String title;
  final String category;
  final String amount;
  final String date;
  final IconData icon;
  final Color color;
  final bool income;

  int get amountCents =>
      (double.parse(amount.replaceAll(RegExp(r'[^0-9.]'), '')) * 100).round();

  DateTime get occurredAt {
    final parts = date.replaceAll(',', '').split(' ');
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return DateTime(
      int.parse(parts[2]),
      months.indexOf(parts[0]) + 1,
      int.parse(parts[1]),
    );
  }
}
