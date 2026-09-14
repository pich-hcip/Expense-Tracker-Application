import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/transaction_data.dart';

String reportMoney(int cents) {
  final parts = (cents.abs() / 100).toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]},',
  );
  return '${cents < 0 ? '-' : ''}\$$whole.${parts[1]}';
}

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, this.embedded = false, this.onBack});
  final bool embedded;
  final VoidCallback? onBack;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _ink = Color(0xFF2D3748);
  static const _muted = Color(0xFF7C8CA7);

  @override
  Widget build(BuildContext context) {
    final records = transactionSections
        .expand((s) => s.items)
        .where(
          (t) =>
              t.occurredAt.year == _month.year &&
              t.occurredAt.month == _month.month,
        )
        .toList();
    final income = records
        .where((t) => t.income)
        .fold(0, (sum, t) => sum + t.amountCents);
    final expenses = records.where((t) => !t.income).toList();
    final expense = expenses.fold(0, (sum, t) => sum + t.amountCents);
    final categories = <String, int>{};
    final days = List<int>.filled(
      DateTime(_month.year, _month.month + 1, 0).day,
      0,
    );
    for (final t in expenses) {
      categories.update(
        t.category,
        (v) => v + t.amountCents,
        ifAbsent: () => t.amountCents,
      );
      days[t.occurredAt.day - 1] += t.amountCents;
    }
    final now = DateTime.now();
    final options = <DateTime>{
      DateTime(now.year, now.month),
      _month,
      ...transactionSections
          .expand((s) => s.items)
          .map((t) => DateTime(t.occurredAt.year, t.occurredAt.month)),
    }.toList()..sort((a, b) => b.compareTo(a));
    String label(DateTime date) =>
        date.year == now.year && date.month == now.month
        ? 'This Month'
        : '${_months[date.month - 1]} ${date.year}';
    final content = ListView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: widget.onBack ?? () => Navigator.maybePop(context),
              tooltip: 'Back',
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xFFF2F7FF),
                foregroundColor: const Color(0xFF0962B9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 22),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Reports',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            PopupMenuButton<DateTime>(
              tooltip: 'Select report month',
              initialValue: _month,
              onSelected: (value) => setState(() => _month = value),
              itemBuilder: (_) => options
                  .map((m) => PopupMenuItem(value: m, child: Text(label(m))))
                  .toList(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE4EAF3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: _muted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label(_month),
                      style: const TextStyle(
                        fontSize: 11,
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _card(
          Column(
            children: [
              _total('Income', income, const Color(0xFF0BBF91)),
              const Divider(height: 1, color: Color(0xFFE8EDF4)),
              _total('Expense', expense, const Color(0xFFFF4352)),
              const Divider(height: 1, color: Color(0xFFE8EDF4)),
              _total('Balance', income - expense, _ink),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heading('Expense Trend'),
              const SizedBox(height: 18),
              if (expenses.isEmpty)
                const SizedBox(
                  height: 150,
                  child: Center(
                    child: Text(
                      'No expenses this month',
                      style: TextStyle(color: _muted),
                    ),
                  ),
                )
              else
                Semantics(
                  label:
                      'Daily expenses for ${label(_month)}. Total ${reportMoney(expense)}.',
                  child: SizedBox(
                    height: 155,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: _TrendPainter(days, _months[_month.month - 1]),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _card(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _heading('Expense by Category'),
              const SizedBox(height: 12),
              if (categories.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No category spending this month.',
                    style: TextStyle(color: _muted),
                  ),
                ),
              for (final category in categories.entries)
                Builder(
                  builder: (_) {
                    final record = expenses.firstWhere(
                      (t) => t.category == category.key,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: record.color.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              record.icon,
                              size: 21,
                              color: record.color,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        category.key,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: _ink,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      reportMoney(category.value),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: _ink,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                LinearProgressIndicator(
                                  value: expense == 0
                                      ? 0
                                      : category.value / expense,
                                  minHeight: 5,
                                  borderRadius: BorderRadius.circular(5),
                                  backgroundColor: const Color(0xFFE2E8F0),
                                  color: record.color,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
    if (widget.embedded) return ColoredBox(color: Colors.white, child: content);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: content),
    );
  }

  Widget _heading(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      color: _ink,
    ),
  );
  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Color(0x050F2748),
          blurRadius: 18,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: child,
  );
  Widget _total(String label, int value, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: _muted, fontSize: 14),
          ),
        ),
        Text(
          reportMoney(value),
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.days, this.month);
  final List<int> days;
  final String month;

  @override
  void paint(Canvas canvas, Size size) {
    const purple = Color(0xFF921BCD);
    final plot = Rect.fromLTRB(38, 6, size.width - 5, size.height - 25);
    final maximum = math.max(100, (days.reduce(math.max) / 100).ceil() * 100);
    void text(String value, Offset point) {
      final painter = TextPainter(
        text: TextSpan(
          text: value,
          style: const TextStyle(fontSize: 9, color: Color(0xFF8FA0BC)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(canvas, point);
    }

    for (var i = 0; i <= 4; i++) {
      final y = plot.bottom - plot.height * i / 4;
      text((maximum * i / 400).toStringAsFixed(0), Offset(0, y - 5));
      for (double x = plot.left; x < plot.right; x += 7) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + 4, plot.right), y),
          Paint()
            ..color = const Color(0xFFE3EAF5)
            ..strokeWidth = 1,
        );
      }
    }
    final points = [
      for (var i = 0; i < days.length; i++)
        Offset(
          plot.left + plot.width * i / (days.length - 1),
          plot.bottom - plot.height * days[i] / maximum,
        ),
    ];
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      line.lineTo(point.dx, point.dy);
    }
    final fill = Path.from(line)
      ..lineTo(plot.right, plot.bottom)
      ..lineTo(plot.left, plot.bottom)
      ..close();
    canvas.drawPath(fill, Paint()..color = purple.withValues(alpha: 0.06));
    canvas.drawPath(
      line,
      Paint()
        ..color = purple
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
    for (var i = 0; i < points.length; i++) {
      if (days[i] > 0) {
        canvas.drawCircle(points[i], 3.5, Paint()..color = Colors.white);
        canvas.drawCircle(points[i], 2.5, Paint()..color = purple);
      }
    }
    for (final day in [1, 8, 15, 22, days.length]) {
      final x = plot.left + plot.width * (day - 1) / (days.length - 1);
      text(
        '$month $day',
        Offset((x - 12).clamp(plot.left, size.width - 33), plot.bottom + 9),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) =>
      oldDelegate.days != days || oldDelegate.month != month;
}

