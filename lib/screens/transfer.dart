import 'package:flutter/material.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _destination;

  static const _banks = [
    _RecentBank('ABA Bank', '•••• 1234 5678', 'assets/images/aba_bank.jpg'),
    _RecentBank('ACLEDA Bank', '•••• 9876 5432', 'assets/images/acleda_bank.png'),
    _RecentBank('Wing', 'Wing Account', 'assets/images/wing_bank.png'),
  ];

  @override
  void dispose() {
    _amountController.dispose();
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
                  _TransferHeader(onBack: () => Navigator.maybePop(context)),
                  const SizedBox(height: 16),
                  const _FieldLabel('From'),
                  const SizedBox(height: 7),
                  const _SourceWallet(),
                  const SizedBox(height: 17),
                  const _FieldLabel('To'),
                  const SizedBox(height: 7),
                  _DestinationField(
                    value: _destination,
                    onChanged: (value) => setState(() => _destination = value),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _FieldLabel('Recent'),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(42, 28),
                          foregroundColor: const Color(0xFF075FAE),
                        ),
                        child: const Text(
                          'See all',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE3E5E8)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        for (var index = 0; index < _banks.length; index++) ...[
                          _RecentBankTile(
                            bank: _banks[index],
                            onTap: () => setState(
                              () => _destination = _banks[index].name,
                            ),
                          ),
                          if (index != _banks.length - 1)
                            const Divider(
                              height: 1,
                              indent: 47,
                              color: Color(0xFFECECEC),
                            ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 17),
                  const _FieldLabel('Amount'),
                  const SizedBox(height: 7),
                  _AmountField(controller: _amountController),
                  const SizedBox(height: 7),
                  const Text(
                    'Available Balance: \$200.00',
                    style: TextStyle(color: Color(0xFF969696), fontSize: 9),
                  ),
                  const SizedBox(height: 16),
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
                      color: Color(0xFF555555),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 7),
                  TextField(
                    controller: _noteController,
                    maxLines: 2,
                    minLines: 1,
                    style: const TextStyle(fontSize: 11),
                    decoration: _inputDecoration('Add a note for this transfer...'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _continueTransfer,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF174DBB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Continue',
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

  void _continueTransfer() {
    if (_destination == null || _amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a destination and enter an amount')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transfer details are ready to review')),
    );
  }
}

class _TransferHeader extends StatelessWidget {
  const _TransferHeader({required this.onBack});

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
        const SizedBox(width: 10),
        const Text(
          'Transfer',
          style: TextStyle(
            color: Color(0xFF202020),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
        color: Color(0xFF555555),
        fontSize: 10,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _SourceWallet extends StatelessWidget {
  const _SourceWallet();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 11),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE3E5E8)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          _CashIcon(),
          SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cash',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 2),
                Text(
                  'Cash in hand',
                  style: TextStyle(color: Color(0xFF8A8A8A), fontSize: 9),
                ),
              ],
            ),
          ),
          Text(
            '\$200.00',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _CashIcon extends StatelessWidget {
  const _CashIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 31,
      height: 31,
      decoration: BoxDecoration(
        color: const Color(0xFFE1FAF0),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Icon(
        Icons.payments_outlined,
        color: Color(0xFF10B981),
        size: 17,
      ),
    );
  }
}

class _DestinationField extends StatelessWidget {
  const _DestinationField({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
      style: const TextStyle(color: Color(0xFF3A3A3A), fontSize: 11),
      decoration: _inputDecoration('Select wallet or bank').copyWith(
        prefixIcon: const Icon(
          Icons.account_balance_wallet_outlined,
          color: Color(0xFF2874BA),
          size: 18,
        ),
      ),
      items: const ['ABA Bank', 'ACLEDA Bank', 'Wing']
          .map((bank) => DropdownMenuItem(value: bank, child: Text(bank)))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _RecentBankTile extends StatelessWidget {
  const _RecentBankTile({required this.bank, required this.onTap});

  final _RecentBank bank;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 47,
        child: Row(
          children: [
            const SizedBox(width: 9),
            ClipOval(
              child: Image.asset(bank.asset, width: 30, height: 30, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bank.name,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bank.account,
                    style: const TextStyle(color: Color(0xFF8C8C8C), fontSize: 8),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF9A9A9A), size: 18),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      decoration: _inputDecoration('0.00').copyWith(
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 13, right: 8),
          child: Text(
            '\$',
            style: TextStyle(
              color: Color(0xFF0962B9),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 34),
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'USD',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 10),
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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

class _RecentBank {
  const _RecentBank(this.name, this.account, this.asset);

  final String name;
  final String account;
  final String asset;
}
