import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker_application/screens/wallet.dart';
import 'package:expense_tracker_application/services/budget_service.dart';

void main() {
  test('Budget uses expenses only and handles exceeded limits', () {
    final summary = BudgetSummary(limit: 112000, now: DateTime(2026, 8, 20));
    expect(summary.spent, 10450);
    expect(summary.remaining, 101550);
    expect(summary.overLimit, isFalse);
    expect(
      BudgetSummary(limit: 10000, now: DateTime(2026, 8, 20)).overLimit,
      isTrue,
    );
    expect(
      BudgetSummary(limit: 15000, now: DateTime(2026, 8, 20)).atRisk,
      isTrue,
    );
    expect(BudgetSummary(limit: 112000, now: DateTime(2026, 9, 9)).spent, 0);
  });
  testWidgets('Wallet opens budget and validates and retains edits', (
    tester,
  ) async {
    monthlyBudget.value = 112000;
    budgetAlertsEnabled.value = true;
    addTearDown(() {
      monthlyBudget.value = 112000;
      budgetAlertsEnabled.value = true;
      budgetHistory.clear();
    });
    await tester.pumpWidget(const MaterialApp(home: WalletScreen()));
    await tester.tap(find.text('Budgets'));
    await tester.pumpAndSettle();
    expect(find.text('Monthly Budget'), findsOneWidget);
    await tester.tap(find.byTooltip('Edit monthly budget'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '0');
    await tester.ensureVisible(find.text('Save Budget'));
    await tester.tap(find.text('Save Budget'));
    await tester.pumpAndSettle();
    expect(monthlyBudget.value, 112000);
    await tester.enterText(find.byType(TextFormField), '500.25');
    await tester.ensureVisible(find.byType(Switch));
    await tester.tap(find.byType(Switch));
    await tester.ensureVisible(find.text('Save Budget'));
    await tester.tap(find.text('Save Budget'));
    await tester.pumpAndSettle();
    expect(monthlyBudget.value, 50025);
    expect(budgetAlertsEnabled.value, isFalse);
    expect(find.text('\$500.25'), findsWidgets);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Budgets'));
    await tester.pumpAndSettle();
    expect(find.text('\$500.25'), findsWidgets);
    await tester.tap(find.byTooltip('Edit monthly budget'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '900');
    await tester.tap(find.byTooltip('Cancel budget changes'));
    await tester.pumpAndSettle();
    expect(monthlyBudget.value, 50025);
    expect(tester.takeException(), isNull);
  });
}
