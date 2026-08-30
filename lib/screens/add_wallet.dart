import 'package:flutter/material.dart';

class AddWalletScreen extends StatefulWidget {
  const AddWalletScreen({super.key});

  @override
  State<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends State<AddWalletScreen> {
  final _nameController = TextEditingController(text: 'My ABA Account');
  final _accountController = TextEditingController();
  final _balanceController = TextEditingController();
  final _noteController = TextEditingController();

  String _walletType = 'Bank';
  String _bank = 'ABA Bank';
  String _currency = 'USD';
  int _selectedColor = 0;

  static const _colors = [
    Color(0xFF4B31D1),
    Color(0xFF11B981),
    Color(0xFFFF3F62),
    Color(0xFFFF9F22),
    Color(0xFF3F82F4),
    Color(0xFF8252E8),
    Color(0xFF697184),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    _balanceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                children: [
                  _Header(onBack: () => Navigator.maybePop(context)),
                  const SizedBox(height: 16),
                  _WalletTypeSelector(
                    selected: _walletType,
                    onSelected: (type) => setState(() => _walletType = type),
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel('Wallet Name'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 11),
                    decoration: _decoration('Wallet name').copyWith(
                      prefixIcon: const Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Color(0xFF2874BA),
                        size: 18,
                      ),
                    ),
                  ),
                  if (_walletType == 'Bank') ...[
                    const SizedBox(height: 13),
                    const _FieldLabel('Bank / Provider'),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _bank,
                      decoration: _decoration('').copyWith(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8),
                          child: ClipOval(
                            child: Image.asset(
                              _bankAsset,
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 11,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 19),
                      items: const ['ABA Bank', 'ACLEDA Bank', 'Wing Bank']
                          .map(
                            (bank) => DropdownMenuItem(
                              value: bank,
                              child: Text(bank),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => _bank = value);
                      },
                    ),
                    const SizedBox(height: 13),
                    const _FieldLabel('Account Number'),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _accountController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      style: const TextStyle(fontSize: 11),
                      decoration: _decoration('Enter account number').copyWith(
                        prefixIcon: const Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xFF2874BA),
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 13),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FieldLabel('Currency'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _currency,
                              decoration: _decoration('').copyWith(
                                prefixIcon: const Icon(
                                  Icons.attach_money_rounded,
                                  color: Color(0xFF2874BA),
                                  size: 18,
                                ),
                              ),
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 11,
                              ),
                              items: const ['USD', 'KHR']
                                  .map(
                                    (currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(currency),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _currency = value);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _FieldLabel('Initial Balance'),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _balanceController,
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              style: const TextStyle(fontSize: 11),
                              decoration: _decoration('0.00').copyWith(
                                prefixIcon: const Icon(
                                  Icons.receipt_long_outlined,
                                  color: Color(0xFF2874BA),
                                  size: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  const Text.rich(
                    TextSpan(
                      text: 'Note ',
                      children: [
                        TextSpan(
                          text: '(optional)',
                          style: TextStyle(color: Color(0xFF9A9A9A)),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      color: Color(0xFF4F4F4F),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _noteController,
                    style: const TextStyle(fontSize: 11),
                    decoration: _decoration('Add a note for this wallet...'),
                  ),
                  const SizedBox(height: 14),
                  const _FieldLabel('Wallet Theme Color'),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 10,
                    children: [
                      for (var index = 0; index < _colors.length; index++)
                        GestureDetector(
                          onTap: () => setState(() => _selectedColor = index),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              color: _colors[index],
                              shape: BoxShape.circle,
                              border: index == _selectedColor
                                  ? Border.all(color: Colors.white, width: 3)
                                  : null,
                              boxShadow: index == _selectedColor
                                  ? [
                                      BoxShadow(
                                        color: _colors[index],
                                        spreadRadius: 2,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: index == _selectedColor
                                ? const Icon(Icons.check, color: Colors.white, size: 13)
                                : null,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 47,
                child: ElevatedButton(
                  onPressed: _saveWallet,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF174DBB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Save Wallet',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _bankAsset => switch (_bank) {
    'ACLEDA Bank' => 'assets/images/acleda_bank.png',
    'Wing Bank' => 'assets/images/wing_bank.png',
    _ => 'assets/images/aba_bank.jpg',
  };

  void _saveWallet() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a wallet name')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet saved')),
    );
    Navigator.maybePop(context);
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
        const SizedBox(width: 9),
        const Text(
          'Add Wallet',
          style: TextStyle(
            color: Color(0xFF202020),
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WalletTypeSelector extends StatelessWidget {
  const _WalletTypeSelector({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const types = [
      ('Cash', Icons.payments_outlined),
      ('Bank', Icons.account_balance_outlined),
      ('E-wallet', Icons.account_balance_wallet_outlined),
    ];
    return Row(
      children: [
        for (var index = 0; index < types.length; index++) ...[
          Expanded(
            child: _TypeButton(
              label: types[index].$1,
              icon: types[index].$2,
              selected: selected == types[index].$1,
              onTap: () => onSelected(types[index].$1),
            ),
          ),
          if (index != types.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF145DB6) : const Color(0xFF565656);
    return Material(
      color: selected ? const Color(0xFFF2F7FF) : Colors.white,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          height: 43,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: selected ? const Color(0xFF2874D0) : const Color(0xFFE3E5E8),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF4F4F4F),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

InputDecoration _decoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 10),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFFE1E4E8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(9),
      borderSide: const BorderSide(color: Color(0xFF2874BA)),
    ),
  );
}
