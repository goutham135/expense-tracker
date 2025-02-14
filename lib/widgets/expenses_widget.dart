import "package:expense_management/models/expense.dart";
import "package:flutter/material.dart";

import "../screens/add_expense.dart";


class Expenses extends StatelessWidget {
  String date;
  List expensesList;
  var currencies;
  Function deleteExpense;


  Expenses({
    super.key,
    required this.date,
    required this.expensesList,
    required this.deleteExpense,
    required this.currencies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Text(date, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        ...expensesList.map((expense) => ExpenseDetails(expense: expense, currencies: currencies, deleteExpense: deleteExpense,)),
      ],
    );
  }
}

class ExpenseDetails extends StatelessWidget {
  var currencies;
  Expense expense;
  Function deleteExpense;

  ExpenseDetails({super.key,
    required this.expense,
    required this.currencies,
    required this.deleteExpense,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddExpenseScreen(expense: expense,),));
      },
      child: ListTile(
        title: Text(expense.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${expense.category} - ₹${expense.amount.toStringAsFixed(2)},'),
            if(currencies["USD"] != null && currencies["EUR"] != null && currencies["GBP"] != null)Text('Other currencies: \$${ (expense.amount * currencies["USD"]).toStringAsFixed(2)}, €${(expense.amount * currencies["EUR"]).toStringAsFixed(2)}, £${(expense.amount * currencies["GBP"]).toStringAsFixed(2)}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            deleteExpense(expense.id);
          },
        ),
      ),
    );
  }
}
