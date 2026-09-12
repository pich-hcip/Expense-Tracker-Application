import 'package:flutter/material.dart';


class CategoryExpense {
  final String name;
  final double amount;
  final double percent;
  final Color color;
  final IconData icon;

  const CategoryExpense({
    required this.name,
    required this.amount,
    required this.percent,
    required this.color,
    required this.icon,
  });
}

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  // Later you can replace these with real numbers from your app.

  static const double income = 2500.00;
  static const double expense = 1800.00;
  static const double balance = 700.00;

  // Points for the "Expense Trend" chart (one value per week/day).
  static const List<double> chartValues = [
    500, 950, 650, 850, 1350, 1600, 1200, 1550, 1900,
  ];

  // Labels shown under the chart. We only have 5 labels for 9 points,
  // so they are spread out evenly (see _buildChartLabels below).
  static const List<String> chartLabels = [
    'May 1', 'May 8', 'May 15', 'May 22', 'May 29',
  ];

  static const List<CategoryExpense> categories = [
    CategoryExpense(
      name: 'Food',
      amount: 450.00,
      percent: 0.45,
      color: Colors.orange,
      icon: Icons.local_cafe_outlined,
    ),
    CategoryExpense(
      name: 'Shopping',
      amount: 380.00,
      percent: 0.38,
      color: Colors.pink,
      icon: Icons.shopping_bag_outlined,
    ),
    CategoryExpense(
      name: 'Bills & Utilities',
      amount: 670.00,
      percent: 0.67,
      color: Colors.blue,
      icon: Icons.receipt_long_outlined,
    ),
    CategoryExpense(
      name: 'Entertainment',
      amount: 300.00,
      percent: 0.30,
      color: Colors.purple,
      icon: Icons.play_circle_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Top bar ----------
              _buildTopBar(context),

              const SizedBox(height: 20),

              // ---------- Summary card ----------
              _buildSummaryCard(),

              const SizedBox(height: 24),

              // ---------- Expense Trend title ----------
              const Text(
                'Expense Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // ---------- Chart card ----------
              _buildChartCard(),

              const SizedBox(height: 24),

              // ---------- Expense by Category title ----------
              const Text(
                'Expense by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // ---------- Category list ----------
              // We turn each item in `categories` into a widget using .map()
              ...categories.map((category) => _buildCategoryRow(category)),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------
  // Small reusable functions below (easy to read)
  // ---------------------------------------------

  // Top bar: back button + "Reports" title + "This Month" button
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Reports',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Spacer(), // pushes the button below to the right side
        OutlinedButton.icon(
          onPressed: () {
            // TODO: open a month picker
          },
          icon: const Icon(Icons.calendar_today_outlined, size: 16),
          label: const Text('This Month'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }

  // White card with Income / Expense / Balance rows
  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSummaryRow('Income', income, Colors.green),
          const Divider(height: 24),
          _buildSummaryRow('Expense', expense, Colors.red),
          const Divider(height: 24),
          _buildSummaryRow('Balance', balance, Colors.black87),
        ],
      ),
    );
  }

  // One row inside the summary card, e.g. "Income   $2,500.00"
  Widget _buildSummaryRow(String label, double amount, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  // Card that contains the line chart + its labels
  Widget _buildChartCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 16, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          // Row = [ y-axis numbers ] + [ the actual chart drawing ]
          SizedBox(
            height: 160,
            child: Row(
              children: [
                _buildYAxisLabels(),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomPaint(
                    // painter does the actual drawing, see LineChartPainter below
                    painter: LineChartPainter(values: chartValues),
                    child: Container(), // gives CustomPaint something to size itself against
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // x-axis labels (May 1, May 8, ...), spaced evenly under the chart
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: chartLabels
                  .map((label) => Text(
                        label,
                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // The numbers on the left side of the chart: 2K, 1.5K, 1K, 500, 0
  Widget _buildYAxisLabels() {
    const labels = ['2K', '1.5K', '1K', '500', '0'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels
          .map((label) => Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ))
          .toList(),
    );
  }

  // One row inside "Expense by Category": icon + name + progress bar + amount
  Widget _buildCategoryRow(CategoryExpense category) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored circle icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: category.color),
          ),

          const SizedBox(width: 14),

          // Name + progress bar (takes the remaining space)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: category.percent, // 0.0 -> empty, 1.0 -> full
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(category.color),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Amount on the right
          Text(
            '\$${category.amount.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// =====================================================
// LINE CHART PAINTER
// =====================================================
// This class draws the purple line + dots + light purple
// area fill you see in the "Expense Trend" card.
// CustomPainter gives us a blank canvas to draw shapes on.
class LineChartPainter extends CustomPainter {
  final List<double> values;

  LineChartPainter({required this.values});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    // Find the highest value so we know how to scale everything
    // to fit inside the available height (2000 matches our "2K" label).
    const double maxValue = 2000;

    // ---------- Step 1: draw light dashed horizontal grid lines ----------
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      _drawDashedLine(canvas, Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // ---------- Step 2: work out the (x, y) position of every point ----------
    final List<Offset> points = [];
    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height - (values[i] / maxValue * size.height);
      points.add(Offset(x, y));
    }

    // ---------- Step 3: draw the light purple area under the line ----------
    final areaPath = Path()..moveTo(points.first.dx, size.height);
    for (final point in points) {
      areaPath.lineTo(point.dx, point.dy);
    }
    areaPath.lineTo(points.last.dx, size.height);
    areaPath.close();

    final areaPaint = Paint()..color = Colors.deepPurple.withValues(alpha: 0.08);
    canvas.drawPath(areaPath, areaPaint);

    // ---------- Step 4: draw the purple line connecting every point ----------
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }

    final linePaint = Paint()
      ..color = Colors.deepPurple
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(linePath, linePaint);

    // ---------- Step 5: draw a small dot on every point ----------
    final dotPaint = Paint()..color = Colors.deepPurple;
    for (final point in points) {
      canvas.drawCircle(point, 3.5, dotPaint);
    }
  }

  // Helper that draws a horizontal line made of small dashes,
  // instead of one solid line (matches the dotted grid in the design).
  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double distance = 0;
    final totalDistance = (end.dx - start.dx);

    while (distance < totalDistance) {
      canvas.drawLine(
        Offset(start.dx + distance, start.dy),
        Offset(start.dx + distance + dashWidth, start.dy),
        paint,
      );
      distance += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    // Only redraw if the data actually changed
    return oldDelegate.values != values;
  }
}