import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpensePieChart extends StatelessWidget {
  final List<Expense> expenses;

  ExpensePieChart({required this.expenses});

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    List<PieChartSectionData> sections = categoryTotals.entries
        .map((entry) => PieChartSectionData(
      value: entry.value,
      title: '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
      color: _getCategoryColor(entry.key),
      radius: 60,
    ))
        .toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Expenses by Category", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.blue;
      case 'Travel':
        return Colors.green;
      case 'Bills':
        return Colors.orange;
      case 'Shopping':
        return Colors.purple;
      case 'Other':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}