import 'package:flutter/material.dart';

import 'add_wallet.dart';
import 'category.dart';
import 'transaction.dart';
import 'transfer.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  static const _wallets = [
    _Wallet('Cash', 'Cash in hand', '\$ 350.00', Icons.account_balance_wallet, Color(0xFF10B981)),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                children: [
                  const _WalletHeader(),
                  const SizedBox(height: 14),
                  const _WalletBalanceCard(),
                  const SizedBox(height: 16),
                  const Text(
                    'My Wallets',
                    style: TextStyle(
                      color: Color(0xFF262626),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 9),
                  for (final wallet in _wallets) ...[
                    _WalletTile(wallet: wallet),
                    const SizedBox(height: 9),
                  ],
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
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
                        color: Color(0xFF72A9DF),
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
                ],
              ),
            ),
            _WalletNavigation(
              onHome: () => Navigator.maybePop(context),
              onTransactions: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const TransactionPage(),
                ),
              ),
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
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Wallets',
          style: TextStyle(
            color: Color(0xFF202020),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F7FC),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: Color(0xFF3478D4),
                size: 20,
              ),
              Positioned(
                right: 8,
                top: 7,
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
      ],
    );
  }
}

class _WalletBalanceCard extends StatelessWidget {
  const _WalletBalanceCard();

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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(color: Color(0xFFB9CDF7), fontSize: 10),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.visibility_outlined, color: Color(0xFFB9CDF7), size: 15),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  '\$14,248.50',
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
            width: 53,
            height: 43,
            decoration: BoxDecoration(
              color: const Color(0xFF6D8BD0),
              borderRadius: BorderRadius.circular(9),
            ),
            child: const Icon(
              Icons.account_balance_wallet_rounded,
              color: Color(0xFF173D94),
              size: 33,
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
            decoration: BoxDecoration(color: wallet.color, shape: BoxShape.circle),
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
              if (action == _WalletAction.transfer) {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const TransferScreen(),
                  ),
                );
                return;
              }

              final actionName = switch (action) {
                _WalletAction.edit => 'Edit',
                _WalletAction.transfer => 'Transfer',
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
                value: _WalletAction.transfer,
                height: 36,
                child: _WalletMenuItem(
                  icon: Icons.swap_horiz_rounded,
                  label: 'Transfer',
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
          _WalletNavItem(icon: Icons.home_outlined, label: 'Home', onTap: onHome),
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
          const _WalletNavItem(
            icon: Icons.insert_chart_outlined_rounded,
            label: 'Report',
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

enum _WalletAction { edit, transfer, delete }
