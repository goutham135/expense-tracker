import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class ExpenseSummaryScreen extends StatelessWidget {
  const ExpenseSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense Summary")),
      body: StreamBuilder<List<Expense>>(
        stream: ExpenseService().getExpenses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses added yet.'));
          }
          final expenses = snapshot.data!;
          return SingleChildScrollView(
            child: _buildSummary(expenses),
          );
        },
      )
    );
  }

  Widget _buildSummary(List<Expense> expenses) {
    double totalMonthlyExpense = _calculateMonthlyTotal(expenses);
    Map<String, double> categoryBreakdown = _calculateCategoryBreakdown(expenses);

    return Column(
      children: [
        _buildTotalCard(totalMonthlyExpense),
        _buildCategoryPieChart(categoryBreakdown),
        _buildCategoryBarChart(categoryBreakdown),
      ],
    );
  }

  Widget _buildTotalCard(double total) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Total Expenses This Month", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("₹${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPieChart(Map<String, double> categoryData) {
    List<PieChartSectionData> sections = categoryData.entries.map((entry) {
      return PieChartSectionData(
        value: entry.value,
        title: '${entry.key}\n₹${entry.value.toStringAsFixed(2)}',
        color: _getCategoryColor(entry.key),
        radius: 60,
      );
    }).toList();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Category-wise Spending", style: TextStyle(fontSize: 18)),
            SizedBox(height: 200, child: PieChart(PieChartData(sections: sections, centerSpaceRadius: 40))),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBarChart(Map<String, double> categoryData) {
    List<BarChartGroupData> barGroups = categoryData.entries.map((entry) {
      return BarChartGroupData(
        x: categoryData.keys.toList().indexOf(entry.key),
        barRods: [
          BarChartRodData(toY: entry.value, color: _getCategoryColor(entry.key), width: 16),
        ],
      );
    }).toList();

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Spending Breakdown", style: TextStyle(fontSize: 18)),
            SizedBox(height: 200, child: BarChart(BarChartData(barGroups: barGroups))),
          ],
        ),
      ),
    );
  }

  double _calculateMonthlyTotal(List<Expense> expenses) {
    DateTime now = DateTime.now();
    return expenses.where((e) => e.date.month == now.month && e.date.year == now.year)
        .fold(0, (sum, e) => sum + e.amount);
  }

  Map<String, double> _calculateCategoryBreakdown(List<Expense> expenses) {
    Map<String, double> breakdown = {};
    for (var e in expenses) {
      breakdown[e.category] = (breakdown[e.category] ?? 0) + e.amount;
    }
    return breakdown;
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food': return Colors.blue;
      case 'Travel': return Colors.green;
      case 'Bills': return Colors.orange;
      case 'Shopping': return Colors.purple;
      case 'Other': return Colors.red;
      default: return Colors.grey;
    }
  }
}
