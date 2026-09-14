import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/budget_service.dart';
import 'report.dart' show reportMoney;

class SetBudgetScreen extends StatefulWidget {
  const SetBudgetScreen({super.key});

  @override
  State<SetBudgetScreen> createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends State<SetBudgetScreen> {
  static const _blue = Color(0xFF204ABB);
  final _form = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late int _cents;
  late bool _alerts;
  late final double _sliderMaximum;

  @override
  void initState() {
    super.initState();
    _cents = monthlyBudget.value;
    _amount = TextEditingController(text: (_cents / 100).toStringAsFixed(2));
    _alerts = budgetAlertsEnabled.value;
    _sliderMaximum = math.max(350000, _cents).toDouble();
  }

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    if (!_form.currentState!.validate()) return;
    final cents = (double.parse(_amount.text.trim()) * 100).round();
    budgetAlertsEnabled.value = _alerts;
    monthlyBudget.value = cents;
    final now = DateTime.now();
    budgetHistory[DateTime(now.year, now.month)] = cents;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final previous = budgetHistory[DateTime(now.year, now.month - 1)];
    final difference = previous == null ? null : _cents - previous;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF254CC7), Color(0xFF152342)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Cancel budget changes',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFFCCDBFF),
                        size: 23,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Set Monthly Budget',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 25,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: math.max(0, constraints.maxHeight - 50),
                          ),
                          child: Form(
                            key: _form,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'How much do you want to Budget this month?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF9CA5B4),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                TextFormField(
                                  controller: _amount,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: const InputDecoration(
                                    prefixText: '\$ ',
                                    border: InputBorder.none,
                                    semanticCounterText:
                                        'Monthly budget in dollars',
                                  ),
                                  onChanged: (value) {
                                    final amount = double.tryParse(value);
                                    if (amount != null &&
                                        amount.isFinite &&
                                        amount >= 0 &&
                                        amount <= 999999999) {
                                      setState(
                                        () => _cents = (amount * 100).round(),
                                      );
                                    }
                                  },
                                  validator: (value) {
                                    final amount = double.tryParse(
                                      value?.trim() ?? '',
                                    );
                                    if (amount == null ||
                                        !amount.isFinite ||
                                        amount <= 0 ||
                                        amount > 999999999 ||
                                        !RegExp(
                                          r'^\d+(\.\d{1,2})?$',
                                        ).hasMatch(value!.trim())) {
                                      return 'Enter a positive amount (up to 2 decimals)';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 18),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    trackHeight: 46,
                                    activeTrackColor: const Color(0xFF1D4BAB),
                                    inactiveTrackColor: const Color(0xFFE5E7EB),
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 0,
                                    ),
                                    overlayShape:
                                        SliderComponentShape.noOverlay,
                                    trackShape:
                                        const RoundedRectSliderTrackShape(),
                                  ),
                                  child: Slider(
                                    value: _cents.toDouble().clamp(
                                      0,
                                      math.max(
                                        _sliderMaximum,
                                        _cents.toDouble(),
                                      ),
                                    ),
                                    min: 0,
                                    max: math.max(
                                      _sliderMaximum,
                                      _cents.toDouble(),
                                    ),
                                    semanticFormatterCallback: (value) =>
                                        reportMoney(value.round()),
                                    onChanged: (value) => setState(() {
                                      _cents = (value / 100).round() * 100;
                                      _amount.text = (_cents / 100)
                                          .toStringAsFixed(2);
                                    }),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '\$0',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      reportMoney(
                                        math.max(
                                          _sliderMaximum.toInt(),
                                          _cents,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 34),
                                const Text(
                                  'Compared to last month',
                                  style: TextStyle(
                                    color: Color(0xFF89949F),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Color(0xFF39BDDF),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F7F9),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        difference == null || difference == 0
                                            ? Icons.horizontal_rule
                                            : difference > 0
                                            ? Icons.north_east
                                            : Icons.south_east,
                                        size: 20,
                                        color: const Color(0xFFFF5454),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          previous == null
                                              ? 'No budget recorded for last month.'
                                              : '${reportMoney(difference!.abs())} ${difference >= 0 ? 'higher' : 'lower'} than last month\n(${reportMoney(previous)})',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF8A8A8A),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 34),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Overspending alerts',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Notify me at 80% of budget',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: _alerts,
                                      activeThumbColor: Colors.white,
                                      activeTrackColor: _blue,
                                      onChanged: (value) =>
                                          setState(() => _alerts = value),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF264DD0),
                                        Color(0xFF152342),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x302443BD),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _save,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size.fromHeight(54),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      'Save Budget',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
