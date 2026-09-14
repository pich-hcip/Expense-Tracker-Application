import 'package:flutter/foundation.dart';
import '../models/transaction_data.dart';

/// Shared session state, matching the app's local transaction data.
final monthlyBudget = ValueNotifier<int>(112000);
final budgetAlertsEnabled = ValueNotifier<bool>(true);
final budgetHistory = <DateTime, int>{};

class BudgetSummary {
  BudgetSummary({required this.limit, DateTime? now})
    : date = now ?? DateTime.now();
  final int limit;
  final DateTime date;

  int get spent => transactionSections
      .expand((s) => s.items)
      .where(
        (t) =>
            !t.income &&
            t.occurredAt.year == date.year &&
            t.occurredAt.month == date.month,
      )
      .fold(0, (sum, t) => sum + t.amountCents);
  int get remaining => limit - spent;
  double get used => limit > 0 ? spent / limit : 0;
  bool get overLimit => spent > limit;
  bool get atRisk =>
      !overLimit &&
      spent / date.day * DateTime(date.year, date.month + 1, 0).day > limit;
  String get status => overLimit
      ? '1 budget over limit'
      : atRisk
      ? 'On track to exceed budget'
      : 'Within monthly budget';
}
