import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int _selectedIndex = 1;
  String _filterType = 'All'; // All, Income, Expense

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 16),

            // Filter Tabs
            _buildFilterTabs(),
            const SizedBox(height: 24),

            // Transactions List
            Expanded(
              child: _buildTransactionsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFF1F2937),
              size: 24,
            ),
          ),
          const Text(
            'Transactions',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.search,
              color: Color(0xFF666666),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildFilterButton('All'),
          const SizedBox(width: 12),
          _buildFilterButton('Income'),
          const SizedBox(width: 12),
          _buildFilterButton('Expense'),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label) {
    bool isSelected = _filterType == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E40AF) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : const Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  Widget _buildTransactionsList() {
    final transactionsData = [
      {
        'section': 'Today',
        'transactions': [
          {
            'icon': Icons.fastfood,
            'title': 'Lunch',
            'category': 'Food',
            'amount': '-\$13.50',
            'date': 'August 20, 2026',
            'color': const Color(0xFFF97316),
            'bgColor': const Color(0xFFFFE8D6),
            'isIncome': false,
          },
          {
            'icon': Icons.attach_money,
            'title': 'Salary',
            'category': 'Income',
            'amount': '+\$1,350.00',
            'date': 'August 20, 2026',
            'color': const Color(0xFF10B981),
            'bgColor': const Color(0xFFECFDF5),
            'isIncome': true,
          },
          {
            'icon': Icons.local_cafe,
            'title': 'Coffee',
            'category': 'Food',
            'amount': '-\$13.50',
            'date': 'August 20, 2026',
            'color': const Color(0xFFF97316),
            'bgColor': const Color(0xFFFFE8D6),
            'isIncome': false,
          },
        ],
      },
      {
        'section': 'Yesterday',
        'transactions': [
          {
            'icon': Icons.local_taxi,
            'title': 'Taxi',
            'category': 'Food',
            'amount': '-\$13.50',
            'date': 'August 20, 2026',
            'color': const Color(0xFFF97316),
            'bgColor': const Color(0xFFFFE8D6),
            'isIncome': false,
          },
          {
            'icon': Icons.lightbulb,
            'title': 'Electricity Bill',
            'category': 'Food',
            'amount': '-\$50.50',
            'date': 'August 20, 2026',
            'color': const Color(0xFFF97316),
            'bgColor': const Color(0xFFFFE8D6),
            'isIncome': false,
          },
        ],
      },
      {
        'section': 'August 25, 2026',
        'transactions': [
          {
            'icon': Icons.shopping_bag,
            'title': 'Clothes',
            'category': 'Food',
            'amount': '-\$13.50',
            'date': 'August 20, 2026',
            'color': const Color(0xFFF97316),
            'bgColor': const Color(0xFFFFE8D6),
            'isIncome': false,
          },
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: transactionsData.length,
      itemBuilder: (context, sectionIndex) {
        final section = transactionsData[sectionIndex];
        final transactions = section['transactions'] as List;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                section['section'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ...List.generate(transactions.length, (transactionIndex) {
              final transaction = transactions[transactionIndex];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: transaction['bgColor'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          transaction['icon'] as IconData,
                          color: transaction['color'] as Color,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Title and Category
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction['title'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1F2937),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction['category'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF999999),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Amount and Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            transaction['amount'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: transaction['isIncome'] as bool
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction['date'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (sectionIndex < transactionsData.length - 1)
              const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFFCCCCCC),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}