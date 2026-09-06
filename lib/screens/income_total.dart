import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hides "DEBUG" banner
      home: const IncomeScreen(),
    );
  }
}


// A simple "blueprint" for one transaction.
// Instead of using Map<String, String> everywhere,
// a class makes the code easier to read and safer to use.

class Transaction {
  final String title;
  final String date;
  final String amount;

  const Transaction({
    required this.title,
    required this.date,
    required this.amount,
  });
}

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  // Main color used for the icons in this screen
  static const Color greenColor = Color(0xFF1DB975);

  // Sample data. Later, you can replace this list with real data
  // coming from a database or an API.
  static const List<Transaction> transactions = [
    Transaction(title: 'Salary', date: 'August 20, 2026', amount: '+\$1,350.00'),
    Transaction(title: 'Freelance Work', date: 'August 20, 2026', amount: '+\$13.25'),
    Transaction(title: 'Investment Income', date: 'August 20, 2026', amount: '+\$13.25'),
    Transaction(title: 'Side Hustle', date: 'August 20, 2026', amount: '+\$13.25'),
    Transaction(title: 'Bonus', date: 'August 20, 2026', amount: '+\$13.25'),
    Transaction(title: 'Cashback', date: 'August 20, 2026', amount: '+\$13.25'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Top bar (back button + title) ----------
              _buildTopBar(context),

              const SizedBox(height: 20),

              // ---------- Total Income Card ----------
              _buildTotalIncomeCard(),

              const SizedBox(height: 24),

              // ---------- "Recent Transactions" label ----------
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ---------- List of transactions ----------
              // Expanded lets the list take the remaining space and scroll
              // if there are more items than fit on the screen.
              Expanded(
                child: ListView.builder(
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionRow(transactions[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // Small reusable functions below (easy to read)

  // Top bar with a round back button and the "Income" title
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Round back button
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              // Go back to the previous screen
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Income',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // White rounded card showing the total income
  Widget _buildTotalIncomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300), // light border line
      ),
      child: Row(
        children: [
          // Green circle icon with a dollar sign
          _buildGreenCircleIcon(size: 55, iconSize: 26),

          const SizedBox(width: 16),

          // Text column: label, big amount, small note
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Total Income',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 4),
              Text(
                '\$ 1,350.00',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '40% of total expense',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // One row inside the "Recent Transactions" list
  Widget _buildTransactionRow(Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Small green circle icon
          _buildGreenCircleIcon(size: 45, iconSize: 20),

          const SizedBox(width: 14),

          // Title + date (takes up the remaining space)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.date,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Amount on the right side
          Text(
            transaction.amount,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Reusable green circle with a dollar sign icon.
  // Used for both the big card icon and the small list icons.
  Widget _buildGreenCircleIcon({required double size, required double iconSize}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: greenColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.attach_money,
        color: Colors.white,
        size: iconSize,
      ),
    );
  }
}