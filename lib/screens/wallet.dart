import 'package:flutter/material.dart';

import 'add_wallet.dart';
import 'category.dart';
import 'edit_wallet.dart';
import 'transaction.dart';
import 'report.dart';
import 'budget.dart';
import '../services/budget_service.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, this.embedded = false});

  final bool embedded;

  static const _wallets = [
    _Wallet(
      'Cash',
      'Cash in hand',
      '\$ 350.00',
      Icons.account_balance_wallet,
      Color(0xFF10B981),
    ),
    _Wallet(
      'ACLEDA Bank',
      'ACLEDA Account',
      '\$ 350.00',
      Icons.savings_rounded,
      Color(0xFF153E80),
      assetPath: 'assets/images/acleda_bank.png',
    ),
    _Wallet(
      'ABA Bank',
      'ABA Account',
      '\$ 350.00',
      Icons.account_balance_rounded,
      Color(0xFF08798B),
      assetPath: 'assets/images/aba_bank.jpg',
    ),
    _Wallet(
      'Wing Bank',
      'Wing Account',
      '\$ 350.00',
      Icons.credit_card_rounded,
      Color(0xFF91C52B),
      assetPath: 'assets/images/wing_bank.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            children: [
              const _WalletHeader(),
              const SizedBox(height: 14),
              const _WalletBalanceCard(),
              const SizedBox(height: 22),
              const _BudgetCard(),
              const SizedBox(height: 28),
              const Text(
                'My Wallets',
                style: TextStyle(
                  color: Color(0xFF262626),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              for (final wallet in _wallets) ...[
                _WalletTile(wallet: wallet),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 12),
              CustomPaint(
                painter: _DashedBorderPainter(),
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AddWalletScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: const Text('Add Wallets'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1264B5),
                    side: const BorderSide(
                      color: Colors.transparent,
                      style: BorderStyle.solid,
                    ),
                    minimumSize: const Size.fromHeight(42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!embedded)
          _WalletNavigation(
            onHome: () => Navigator.maybePop(context),
            onTransactions: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const TransactionPage()),
            ),
            onAdd: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const CategoryScreen()),
            ),
          ),
      ],
    );

    if (embedded) {
      return ColoredBox(color: Colors.white, child: content);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: content),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Wallets',
      style: TextStyle(
        color: Color(0xFF202020),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: monthlyBudget,
      builder: (context, limit, _) {
        final summary = BudgetSummary(limit: limit);
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const BudgetScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFD8D8D8)),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFF0DBB88),
                    child: Icon(
                      Icons.savings_outlined,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Budgets',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF282828),
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          summary.status,
                          style: TextStyle(
                            fontSize: 11,
                            color: summary.overLimit || summary.atRisk
                                ? const Color(0xFFFF5454)
                                : const Color(0xFF0BAC7D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8190A8),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(9)),
      );
    final paint = Paint()
      ..color = const Color(0xFF72A9DF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (final metric in path.computeMetrics()) {
      for (double offset = 0; offset < metric.length; offset += 4) {
        canvas.drawPath(metric.extractPath(offset, offset + 2), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}

class _WalletBalanceCard extends StatefulWidget {
  const _WalletBalanceCard();

  @override
  State<_WalletBalanceCard> createState() => _WalletBalanceCardState();
}

class _WalletBalanceCardState extends State<_WalletBalanceCard> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126,
      padding: const EdgeInsets.fromLTRB(17, 17, 17, 15),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2858D7), Color(0xFF172653)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(color: Color(0xFFB9CDF7), fontSize: 10),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 28,
                      height: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: _visible ? 'Hide balance' : 'Show balance',
                        onPressed: () => setState(() => _visible = !_visible),
                        icon: Icon(
                          _visible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFFB9CDF7),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  _visible ? '\$14,248.50' : '••••••',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Spacer(),
                Text(
                  'Across 4 wallets',
                  style: TextStyle(color: Color(0xFFB9CDF7), fontSize: 9),
                ),
              ],
            ),
          ),
          Container(
            width: 63,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Color(0xFF8C9BD4),
              size: 56,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}

class _WalletTile extends StatelessWidget {
  const _WalletTile({required this.wallet});

  final _Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE9E9E9)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: wallet.color,
              shape: BoxShape.circle,
            ),
            child: wallet.assetPath == null
                ? Icon(wallet.icon, color: Colors.white, size: 19)
                : ClipOval(
                    child: Image.asset(
                      wallet.assetPath!,
                      width: 34,
                      height: 34,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: const TextStyle(
                    color: Color(0xFF282828),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  wallet.subtitle,
                  style: const TextStyle(color: Color(0xFF999999), fontSize: 8),
                ),
              ],
            ),
          ),
          Text(
            wallet.amount,
            style: const TextStyle(
              color: Color(0xFF333333),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 3),
          PopupMenuButton<_WalletAction>(
            tooltip: 'Wallet options',
            padding: EdgeInsets.zero,
            iconSize: 18,
            color: Colors.white,
            elevation: 5,
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Color(0xFF8CB9E5)),
            ),
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF2874BA),
              size: 18,
            ),
            onSelected: (action) {
              if (action == _WalletAction.edit) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => EditWalletScreen(
                      name: wallet.name,
                      description: wallet.subtitle,
                      balance: wallet.amount.replaceAll(RegExp(r'[^0-9.]'), ''),
                      walletType: wallet.name == 'Cash' ? 'Cash' : 'Bank',
                    ),
                  ),
                );
                return;
              }

              final actionName = switch (action) {
                _WalletAction.edit => 'Edit',
                _WalletAction.delete => 'Delete',
              };
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$actionName ${wallet.name}')),
              );
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: _WalletAction.edit,
                height: 36,
                child: _WalletMenuItem(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Color(0xFF2874BA),
                ),
              ),
              PopupMenuItem(
                value: _WalletAction.delete,
                height: 36,
                child: _WalletMenuItem(
                  icon: Icons.delete_outline_rounded,
                  label: 'Delete',
                  color: Color(0xFFFF3B4E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletMenuItem extends StatelessWidget {
  const _WalletMenuItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 17),
        const SizedBox(width: 9),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _WalletNavigation extends StatelessWidget {
  const _WalletNavigation({
    required this.onHome,
    required this.onTransactions,
    required this.onAdd,
  });

  final VoidCallback onHome;
  final VoidCallback onTransactions;
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
          _WalletNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: onHome,
          ),
          _WalletNavItem(
            icon: Icons.receipt_long_outlined,
            label: 'Transactions',
            onTap: onTransactions,
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
          const _WalletNavItem(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Wallet',
            selected: true,
          ),
          _WalletNavItem(
            icon: Icons.insert_chart_outlined_rounded,
            label: 'Report',
            onTap: () => Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => const ReportPage())),
          ),
        ],
      ),
    );
  }
}

class _WalletNavItem extends StatelessWidget {
  const _WalletNavItem({
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

class _Wallet {
  const _Wallet(
    this.name,
    this.subtitle,
    this.amount,
    this.icon,
    this.color, {
    this.assetPath,
  });

  final String name;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color color;
  final String? assetPath;
}

enum _WalletAction { edit, delete }
