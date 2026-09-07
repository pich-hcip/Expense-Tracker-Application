import 'package:flutter/material.dart';

class EditWalletScreen extends StatefulWidget {
  const EditWalletScreen({
    super.key,
    required this.name,
    required this.description,
    required this.balance,
    this.walletType = 'Cash',
  });

  final String name;
  final String description;
  final String balance;
  final String walletType;

  @override
  State<EditWalletScreen> createState() => _EditWalletScreenState();
}

class _EditWalletScreenState extends State<EditWalletScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _balanceController;

  static const _blue = Color(0xFF2458C6);
  static const _text = Color(0xFF273148);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _balanceController = TextEditingController(text: widget.balance);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  children: [
                    _Header(onBack: () => Navigator.maybePop(context)),
                    const SizedBox(height: 17),
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_outlined,
                                  color: Colors.white,
                                  size: 31,
                                ),
                              ),
                              Positioned(
                                right: -4,
                                bottom: -1,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFDCE5F2)),
                                  ),
                                  child: const Icon(Icons.edit, color: _blue, size: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap to change icon',
                            style: TextStyle(color: Color(0xFF9AA1AE), fontSize: 9),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 23),
                    _FieldLabel('Wallet Name'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'Enter a wallet name'
                          : null,
                      decoration: _inputDecoration(
                        icon: Icons.account_balance_wallet_outlined,
                      ),
                    ),
                    const SizedBox(height: 17),
                    _FieldLabel.optional('Description'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration(icon: Icons.description_outlined),
                    ),
                    const SizedBox(height: 17),
                    _FieldLabel('Wallet Type'),
                    const SizedBox(height: 7),
                    InkWell(
                      onTap: _chooseWalletType,
                      borderRadius: BorderRadius.circular(10),
                      child: InputDecorator(
                        decoration: _inputDecoration(
                          icon: Icons.payments_outlined,
                          suffixIcon: Icons.chevron_right_rounded,
                        ),
                        child: Text(widget.walletType),
                      ),
                    ),
                    const SizedBox(height: 17),
                    _FieldLabel('Current Balance'),
                    const SizedBox(height: 7),
                    TextFormField(
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(suffixText: 'USD'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.maybePop(context),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(49),
                          foregroundColor: _blue,
                          side: const BorderSide(color: _blue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(49),
                          elevation: 4,
                          shadowColor: const Color(0x662458C6),
                          backgroundColor: _blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _chooseWalletType() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet type cannot be changed yet')),
    );
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallet updated')),
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
          color: const Color(0xFFF3F7FD),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(10),
            child: const SizedBox(
              width: 38,
              height: 38,
              child: Icon(Icons.arrow_back, color: _EditWalletScreenState._blue),
            ),
          ),
        ),
        const Expanded(
          child: Text(
            'Edit Wallet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _EditWalletScreenState._text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 38),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label) : optional = false;
  const _FieldLabel.optional(this.label) : optional = true;

  final String label;
  final bool optional;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: label,
        children: optional
            ? const [
                TextSpan(
                  text: ' (Optional)',
                  style: TextStyle(color: Color(0xFF9299A7), fontWeight: FontWeight.w400),
                ),
              ]
            : const [],
      ),
      style: const TextStyle(
        color: _EditWalletScreenState._text,
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

InputDecoration _inputDecoration({
  IconData? icon,
  IconData? suffixIcon,
  String? suffixText,
}) {
  return InputDecoration(
    isDense: true,
    prefixIcon: icon == null
        ? null
        : Icon(icon, color: const Color(0xFF2458C6), size: 19),
    suffixIcon: suffixIcon == null
        ? null
        : Icon(suffixIcon, color: const Color(0xFF65728A), size: 21),
    suffixText: suffixText,
    suffixStyle: const TextStyle(color: Color(0xFF8E95A1), fontSize: 12),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFE0E5EC)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFF2458C6), width: 1.4),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFFF4D4D)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFFF4D4D), width: 1.4),
    ),
  );
}
