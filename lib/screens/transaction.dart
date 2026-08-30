import 'package:flutter/material.dart';

import 'category.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  String _filter = 'All';

  static const _sections = [
    _TransactionSection('Today', [
      _Transaction(
        title: 'Lunch',
        category: 'Food',
        amount: '-\$13.50',
        date: 'August 20, 2026',
        icon: Icons.restaurant_rounded,
        color: Color(0xFFFF7618),
      ),
      _Transaction(
        title: 'Salary',
        category: 'Income',
        amount: '+\$1,350.00',
        date: 'August 20, 2026',
        icon: Icons.attach_money_rounded,
        color: Color(0xFF16B98B),
        income: true,
      ),
      _Transaction(
        title: 'Coffee',
        category: 'Food',
        amount: '-\$13.50',
        date: 'August 20, 2026',
        icon: Icons.coffee_rounded,
        color: Color(0xFFFF7618),
      ),
    ]),
    _TransactionSection('Yesterday', [
      _Transaction(
        title: 'Taxi',
        category: 'Food',
        amount: '-\$13.50',
        date: 'August 20, 2026',
        icon: Icons.local_taxi_rounded,
        color: Color(0xFFFF7618),
      ),
      _Transaction(
        title: 'Electricity Bill',
        category: 'Food',
        amount: '-\$50.50',
        date: 'August 20, 2026',
        icon: Icons.lightbulb_rounded,
        color: Color(0xFFFF7618),
      ),
    ]),
    _TransactionSection('August 25, 2026', [
      _Transaction(
        title: 'Clothes',
        category: 'Food',
        amount: '-\$13.50',
        date: 'August 20, 2026',
        icon: Icons.checkroom_rounded,
        color: Color(0xFFFF7618),
      ),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _Header(onBack: () => Navigator.maybePop(context)),
            _FilterBar(
              selected: _filter,
              onSelected: (value) => setState(() => _filter = value),
            ),
            const Divider(height: 1, color: Color(0xFFEFEFEF)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _visibleSections.length,
                itemBuilder: (context, index) {
                  final section = _visibleSections[index];
                  return _TransactionGroup(
                    section: section,
                    showDivider: index != _visibleSections.length - 1,
                  );
                },
              ),
            ),
            _TransactionNavigation(
              onHome: () => Navigator.maybePop(context),
              onAdd: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CategoryScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_TransactionSection> get _visibleSections {
    if (_filter == 'All') return _sections;
    final wantsIncome = _filter == 'Income';
    return _sections
        .map(
          (section) => _TransactionSection(
            section.label,
            section.items.where((item) => item.income == wantsIncome).toList(),
          ),
        )
        .where((section) => section.items.isNotEmpty)
        .toList();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 14),
      child: Row(
        children: [
          Material(
            color: const Color(0xFFF1F7FF),
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(10),
              child: const SizedBox(
                width: 38,
                height: 38,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Color(0xFF0962B9),
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Transactions',
            style: TextStyle(
              color: Color(0xFF1D1D1F),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final label in const ['All', 'Income', 'Expense'])
            _FilterButton(
              label: label,
              selected: selected == label,
              onTap: () => onSelected(label),
            ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFF0865B9) : Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: selected ? 27 : 20,
            vertical: 10,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF5F5F5F),
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({required this.section, required this.showDivider});

  final _TransactionSection section;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 17, 24, 7),
          child: Text(
            section.label,
            style: const TextStyle(
              color: Color(0xFF4D4D4D),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        for (final item in section.items) _TransactionRow(item: item),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Divider(height: 1, color: Color(0xFFEFEFEF)),
          ),
      ],
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.item});

  final _Transaction item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
            child: Icon(item.icon, color: Colors.white, size: 23),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Color(0xFF292929),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.category,
                  style: const TextStyle(color: Color(0xFF777777), fontSize: 11),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: const TextStyle(
                  color: Color(0xFF242424),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.date,
                style: const TextStyle(color: Color(0xFF777777), fontSize: 9),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionNavigation extends StatelessWidget {
  const _TransactionNavigation({required this.onHome, required this.onAdd});

  final VoidCallback onHome;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, label: 'Home', onTap: onHome),
          const _NavItem(
            icon: Icons.receipt_long_outlined,
            label: 'Transactions',
            selected: true,
          ),
          Material(
            color: const Color(0xFF0865B9),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onAdd,
              customBorder: const CircleBorder(),
              child: const SizedBox(
                width: 54,
                height: 54,
                child: Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ),
          ),
          const _NavItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Wallet',
          ),
          const _NavItem(
            icon: Icons.insert_chart_outlined_rounded,
            label: 'Report',
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
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF0865B9) : const Color(0xFF8B8B8B);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionSection {
  const _TransactionSection(this.label, this.items);

  final String label;
  final List<_Transaction> items;
}

class _Transaction {
  const _Transaction({
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
}
