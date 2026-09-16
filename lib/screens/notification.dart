import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'budget_notification.dart';
import 'walletnoti.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const _notifications = <_NotificationItem>[
    _NotificationItem(
      category: _NotificationFilter.budget,
      section: 'CRITICAL',
      title: "You're over budget",
      message: "You've spent \$1,205 of your\n\$1,120 monthly limit",
      time: '9:32 AM',
      isCritical: true,
    ),
    _NotificationItem(
      category: _NotificationFilter.wallet,
      section: 'CRITICAL',
      title: 'Cash wallet is empty',
      message: 'Balance reached \$0.00',
      time: 'Yesterday',
      isCritical: true,
    ),
    _NotificationItem(
      category: _NotificationFilter.budget,
      section: 'WARNING',
      title: "You're over budget",
      message: "You've spent \$1,205 of your\n\$1,120 monthly limit",
      time: '2 days ago',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final sections = <String, List<_NotificationItem>>{};
    for (final item in _notifications) {
      sections.putIfAbsent(item.section, () => []).add(item);
    }

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
              _Header(onBack: () => Navigator.maybePop(context)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      const SizedBox(height: 22),
                      const _FilterBar(),
                      const SizedBox(height: 31),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                          children: [
                            for (final entry in sections.entries) ...[
                              _SectionTitle(entry.key),
                              const SizedBox(height: 13),
                              for (final item in entry.value) ...[
                                    _NotificationCard(
                                      item: item,
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => item.category ==
                                                  _NotificationFilter.budget
                                              ? const BudgetNotificationScreen()
                                              : const WalletNotificationScreen(),
                                        ),
                                      ),
                                    ),
                                const SizedBox(height: 21),
                              ],
                              const SizedBox(height: 7),
                            ],
                          ],
                        ),
                      ),
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

class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: IconButton(
              tooltip: 'Back',
              onPressed: onBack,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Notifications',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 64),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      children: _NotificationFilter.values.map((filter) {
        final active = filter == _NotificationFilter.all;
        final label = switch (filter) {
          _NotificationFilter.all => 'All(3)',
          _NotificationFilter.budget => 'Budget',
          _NotificationFilter.wallet => 'Wallet',
        };
        return SizedBox(
          width: 66,
          height: 35,
          child: OutlinedButton(
            onPressed: filter == _NotificationFilter.all
                ? () {}
                : () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => filter == _NotificationFilter.budget
                            ? const BudgetNotificationScreen()
                            : const WalletNotificationScreen(),
                      ),
                    ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor:
                  active ? Colors.white : const Color(0xFF747474),
              backgroundColor:
                  active ? const Color(0xFF0061B7) : Colors.white,
              side: const BorderSide(color: Color(0xFF2474D0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF898989),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.item, this.onTap});

  final _NotificationItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = item.isCritical
        ? const Color(0xFFFF5962)
        : const Color(0xFF0968C3);
    final pale = item.isCritical
        ? const Color(0xFFFFF5F5)
        : const Color(0xFFF3F8FE);
    final iconFill = item.isCritical
        ? const Color(0xFFFFD6D9)
        : const Color(0xFFCFE3F7);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(13),
      child: Container(
        constraints: const BoxConstraints(minHeight: 98),
        padding: const EdgeInsets.fromLTRB(12, 10, 9, 10),
        decoration: BoxDecoration(
          color: pale,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: accent.withValues(alpha: .65), width: 1.2),
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: iconFill, shape: BoxShape.circle),
            child: Icon(
              item.category == _NotificationFilter.wallet
                  ? Icons.account_balance_wallet_outlined
                  : Icons.notifications_none_rounded,
              color: accent,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: iconFill,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.category.name.toUpperCase(),
                    style: TextStyle(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        item.time,
                        style: const TextStyle(
                          color: Color(0xFFA1A8B3),
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.message,
                  style: const TextStyle(
                    color: Color(0xFF7C8492),
                    fontSize: 10,
                    height: 1.25,
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

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 3),
      child: Container(
        width: 112,
        height: 4,
        decoration: BoxDecoration(
          color: const Color(0xFF171313),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

enum _NotificationFilter { all, budget, wallet }

class _NotificationItem {
  const _NotificationItem({
    required this.category,
    required this.section,
    required this.title,
    required this.message,
    required this.time,
    this.isCritical = false,
  });

  final _NotificationFilter category;
  final String section;
  final String title;
  final String message;
  final String time;
  final bool isCritical;
}
