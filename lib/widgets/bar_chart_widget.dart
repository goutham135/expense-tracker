import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';

class ExpenseBarChart extends StatelessWidget {
  final List<Expense> expenses;

  const ExpenseBarChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    Map<String, double> dailyTotals = {};

    for (var expense in expenses) {
      String dateKey = "${expense.date.year}-${expense.date.month}-${expense.date.day}";
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0) + expense.amount;
    }

    List<BarChartGroupData> barGroups = dailyTotals.entries.map((entry) {
      return BarChartGroupData(
        x: dailyTotals.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(toY: entry.value, color: Colors.blue, width: 16),
        ],
      );
    }).toList();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Daily Expenses", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: const FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
