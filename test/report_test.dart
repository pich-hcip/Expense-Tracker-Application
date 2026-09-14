import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_application/screens/report.dart';

void main() {
  testWidgets('Report totals match August transactions', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ReportPage()));
    await tester.tap(find.byTooltip('Select report month'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aug 2026').last);
    await tester.pumpAndSettle();
    expect(find.text('\$1,350.00'), findsOneWidget);
    expect(find.text('\$1,245.50'), findsOneWidget);
    expect(find.text('\$104.50'), findsNWidgets(2));
    expect(find.text('Food'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
