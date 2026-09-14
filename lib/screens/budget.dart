import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../services/budget_service.dart';
import 'report.dart' show reportMoney;
import 'set_budget.dart';

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});
  static const _blue = Color(0xFF2443BD);
  static const _ink = Color(0xFF2D3748);
  static const _muted = Color(0xFF94A0B3);

  Future<void> _edit(BuildContext context) => Navigator.of(context).push<void>(
    MaterialPageRoute<void>(builder: (_) => const SetBudgetScreen()),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_blue, Color(0xFF142344)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Budgets',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit monthly budget',
                      onPressed: () => _edit(context),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: ListenableBuilder(
                    listenable: Listenable.merge([
                      monthlyBudget,
                      budgetAlertsEnabled,
                    ]),
                    builder: (context, _) {
                      final limit = monthlyBudget.value;
                      final summary = BudgetSummary(limit: limit);
                      final thresholdAlert =
                          budgetAlertsEnabled.value && summary.used >= 0.8;
                      final warning =
                          summary.overLimit || summary.atRisk || thresholdAlert;
                      final message = summary.overLimit
                          ? 'You have exceeded your monthly budget by ${reportMoney(-summary.remaining)}.'
                          : summary.atRisk
                          ? "You're on track to go over budget by month end at this pace."
                          : thresholdAlert
                          ? 'You have used at least 80% of your monthly budget.'
                          : summary.spent == 0
                          ? 'No expenses recorded this month. Your full budget is available.'
                          : 'Your spending is within your monthly budget.';
                      return Container(
                        padding: const EdgeInsets.fromLTRB(12, 25, 12, 28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: const Color(0xFF35C2FF),
                            width: 3,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Monthly Budget',
                              style: TextStyle(
                                color: _muted,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              reportMoney(limit),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 32),
                            Semantics(
                              label:
                                  '${(summary.used * 100).round()} percent of monthly budget used',
                              child: SizedBox(
                                width: 190,
                                height: 190,
                                child: CustomPaint(
                                  painter: _BudgetRing(summary.used),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${(summary.used * 100).round()}%',
                                          style: const TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w800,
                                            color: _ink,
                                          ),
                                        ),
                                        const Text(
                                          'used',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 34),
                            Row(
                              children: [
                                Expanded(
                                  child: _metric(
                                    'Spent',
                                    reportMoney(summary.spent),
                                    _blue,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 45,
                                  color: const Color(0xFFF0F2F6),
                                ),
                                Expanded(
                                  child: _metric(
                                    summary.remaining < 0
                                        ? 'Over budget'
                                        : 'Remaining',
                                    reportMoney(summary.remaining.abs()),
                                    summary.overLimit
                                        ? const Color(0xFFFF5454)
                                        : const Color(0xFFE1E7F0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: warning
                                    ? const Color(0xFFFFF1F3)
                                    : const Color(0xFFF0FAF6),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    warning
                                        ? Icons.warning_amber_rounded
                                        : Icons.check_circle_outline,
                                    size: 20,
                                    color: warning
                                        ? const Color(0xFFFF6B25)
                                        : const Color(0xFF0BAC7D),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      message,
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 1.4,
                                        color: warning
                                            ? const Color(0xFFD63859)
                                            : const Color(0xFF208164),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 34),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [_blue, Color(0xFF172344)],
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
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(14),
                                  onTap: () => _edit(context),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 18),
                                    child: Text(
                                      'Edit Monthly Budget',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value, Color dot) => Column(
    children: [
      Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
      ),
      const SizedBox(height: 5),
      Text(label, style: const TextStyle(color: _muted, fontSize: 12)),
      const SizedBox(height: 5),
      Text(
        value,
        style: const TextStyle(
          color: _ink,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _BudgetRing extends CustomPainter {
  _BudgetRing(this.used);
  final double used;
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 9;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, paint..color = const Color(0xFFE2E8F1));
    if (used <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * used.clamp(0, 1),
      false,
      paint..color = BudgetScreen._blue,
    );
  }

  @override
  bool shouldRepaint(covariant _BudgetRing oldDelegate) =>
      oldDelegate.used != used;
}
