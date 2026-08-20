import 'package:flutter/material.dart';

import 'category.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<_TransactionItem> _transaction = [
    _TransactionItem(
      title: 'Monthly Salary',
      date: 'May 28, 2026',
      amount: '+\$4,200.00',
      icon: Icons.business_center_outlined,
      iconColor: Color(0xFF0061B7),
      backgroundColor: Color(0xFFE4F4FC),
      isIncome: true,
    ),
    _TransactionItem(
      title: 'Whole Foods Market',
      date: 'May 27, 2026',
      amount: '-\$142.50',
      icon: Icons.shopping_cart_outlined,
      iconColor: Color(0xFF0061B7),
      backgroundColor: Color(0xFFFFE5E8),
    ),
    _TransactionItem(
      title: 'Netflix Subscription',
      date: 'May 25, 2026',
      amount: '-\$15.99',
      icon: Icons.play_circle_outline,
      iconColor: Color(0xFF0061B7),
      backgroundColor: Color(0xFFF3E7FC),
    ),
    _TransactionItem(
      title: 'Stock Dividend',
      date: 'May 24, 2026',
      amount: '+\$85.00',
      icon: Icons.trending_up,
      iconColor: Color(0xFF0787A7),
      backgroundColor: Color(0xFFD8F8E8),
      isIncome: true,
    ),
    _TransactionItem(
      title: 'Starbucks Coffee',
      date: 'May 23, 2026',
      amount: '-\$6.80',
      icon: Icons.local_cafe_outlined,
      iconColor: Color(0xFF0061B7),
      backgroundColor: Color(0xFFFFF2C9),
    ),
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  const _BalanceCard(),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Transactions',
                        style: TextStyle(
                          color: Color(0xFF211F20),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0061B7),
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                        ),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  for (final transaction in _transaction)
                    _TransactionTile(transaction: transaction),
                ],
              ),
            ),
            _BottomNavigation(
              selectedIndex: _selectedIndex,
              onSelected: (index) => setState(() => _selectedIndex = index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _SquareButton(icon: Icons.menu, onTap: () {}),
        const SizedBox(width: 13),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning,',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Alex Morgan',
                style: TextStyle(
                  color: Color(0xFF201E1F),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        _SquareButton(
          icon: Icons.notifications_none,
          showBadge: true,
          onTap: () {},
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0061B7),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330061B7),
            blurRadius: 9,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Balance',
            style: TextStyle(color: Color(0xFF8FC5F3), fontSize: 13),
          ),
          const SizedBox(height: 3),
          const Text(
            '\$14,248.50',
            style: TextStyle(
              color: Colors.white,
              fontSize: 31,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0x337FC0F5), height: 1),
          const SizedBox(height: 17),
          Row(
            children: [
              const Expanded(
                child: _BalanceSummary(
                  label: 'Income',
                  amount: '\$5,240.00',
                  icon: Icons.arrow_upward,
                  iconColor: Color(0xFF11C89D),
                ),
              ),
              Container(width: 1, height: 31, color: const Color(0x337FC0F5)),
              const SizedBox(width: 20),
              const Expanded(
                child: _BalanceSummary(
                  label: 'Expenses',
                  amount: '\$1,120.50',
                  icon: Icons.arrow_downward,
                  iconColor: Color(0xFFFF4360),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({
    required this.label,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String amount;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: const BoxDecoration(
            color: Color(0xFF1674C5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 17),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color(0xFF9FCBF0), fontSize: 11),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction});

  final _TransactionItem transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: transaction.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.iconColor,
              size: 23,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF333031),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  transaction.date,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            transaction.amount,
            style: TextStyle(
              color: transaction.isIncome
                  ? const Color(0xFF0CBF91)
                  : const Color(0xFFFF4352),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF5F9FD),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 42,
          height: 42,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: const Color(0xFF0061B7), size: 22),
              if (showBadge)
                Positioned(
                  right: 9,
                  top: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4352),
                      shape: BoxShape.circle,
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

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.home_outlined, 'Home'),
      (Icons.list_alt_outlined, 'Transactions'),
      (Icons.account_balance_wallet_outlined, 'Wallet'),
      (Icons.person_outline, 'Profile'),
    ];

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: items[0].$1,
            label: items[0].$2,
            selected: selectedIndex == 0,
            onTap: () => onSelected(0),
          ),
          _NavItem(
            icon: items[1].$1,
            label: items[1].$2,
            selected: selectedIndex == 1,
            onTap: () => onSelected(1),
          ),
          Material(
            color: const Color(0xFF0061B7),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const CategoryScreen(),
                  ),
                );
              },
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 52,
                height: 52,
                child: Icon(Icons.add, color: Colors.white, size: 31),
              ),
            ),
          ),
          _NavItem(
            icon: items[2].$1,
            label: items[2].$2,
            selected: selectedIndex == 2,
            onTap: () => onSelected(2),
          ),
          _NavItem(
            icon: items[3].$1,
            label: items[3].$2,
            selected: selectedIndex == 3,
            onTap: () => onSelected(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0061B7) : const Color(0xFF969696);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionItem {
  const _TransactionItem({
    required this.title,
    required this.date,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.isIncome = false,
  });

  final String title;
  final String date;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final bool isIncome;
}
