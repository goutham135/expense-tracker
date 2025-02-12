import 'package:expense_management/screens/expenses_summary_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../heplers.dart';

class FiltersWidget extends ConsumerStatefulWidget {
  StateProvider startDate, endDate, selectedCategory;
  Function applyFilters;

  FiltersWidget({super.key,
    required this.selectedCategory,
    required this.startDate,
    required this.endDate,
    required this.applyFilters,
  });

  @override
  ConsumerState<FiltersWidget> createState() => _FiltersWidgetState();
}

class _FiltersWidgetState extends ConsumerState<FiltersWidget> {


  @override
  Widget build(BuildContext context) {
    var category = ref.watch(widget.selectedCategory);
    var fromDate = ref.watch(widget.startDate);
    var lastDate = ref.watch(widget.endDate);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                value: category,
                items: categoriesFilter.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (value) {
                    ref.read(widget.selectedCategory.notifier).state = value!;
                },
              ),
              // SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  DateTimeRange? picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                    initialDateRange: fromDate == null ? null : DateTimeRange(start: fromDate, end: lastDate)
                  );
                  if (picked != null) {
                      ref.read(widget.startDate.notifier).state = picked.start;
                      ref.read(widget.endDate.notifier).state = picked.end;
                  }
                },
                child: const Text('Pick Date Range'),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     widget.applyFilters();
              //   },
              //   child: Text('Apply Filters'),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  widget.applyFilters();
                },
                child: const Text('Apply Filters'),
              ),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseSummaryScreen(),));
              }, child: const Text('Expenses Summary Reports'))
            ],
          ),
        ],
      ),
    );
  }
}
