
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../heplers.dart';
import '../models/expense.dart';
import '../services/expense_service.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {

  Expense? expense;
  AddExpenseScreen({super.key,
    this.expense,
  });

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController date = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  var _category = StateProvider((ref) => 'Food',);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(milliseconds: 10), () {
      if(widget.expense != null){
        title.text = widget.expense!.title.toString();
        amount.text = widget.expense!.amount.toString();
        ref.read(_category.notifier).state = widget.expense!.category.toString();
        date.text = widget.expense!.date.toString().split(' ')[0];
        selectedDate = widget.expense!.date;
      }
    },);
  }


  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // _formKey.currentState!.save();

      if(widget.expense != null){
        Expense newExpense = Expense(
          id: widget.expense!.id,
          title: title.text,
          amount: double.parse(amount.text),
          category: ref.watch(_category),
          date: selectedDate,
        );
        await ExpenseService().updateExpense(newExpense);
      } else{
        Expense newExpense = Expense(
          id: '',
          title: title.text,
          amount: double.parse(amount.text),
          category: ref.watch(_category),
          date: selectedDate,
        );
        await ExpenseService().addExpense(newExpense);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    String category = ref.watch(_category);
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
                controller: title,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Amount is required' : null,
                controller: amount,
              ),
              DropdownButtonFormField(
                value: category,
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) => ref.read(_category.notifier).state = value.toString(),
                decoration: InputDecoration(labelText: 'Category'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Select Date'),
                readOnly: true,
                controller: date,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() => selectedDate = pickedDate);
                    date.text = pickedDate.toString();
                  }
                },
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     DateTime? pickedDate = await showDatePicker(
              //       context: context,
              //       initialDate: selectedDate,
              //       firstDate: DateTime(2000),
              //       lastDate: DateTime.now(),
              //     );
              //     if (pickedDate != null) {
              //       setState(() => selectedDate = pickedDate);
              //     }
              //   },
              //   child: Text('Pick Date'),
              // ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.expense != null ? 'Update Expense' : 'Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
