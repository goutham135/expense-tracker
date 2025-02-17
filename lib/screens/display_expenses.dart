import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_management/screens/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/currency_service.dart';
import '../services/expense_service.dart';
import '../models/expense.dart';
import '../widgets/expenses_widget.dart';
import '../widgets/filters_widget.dart';
import 'add_expense.dart';
import 'login_screen.dart';

class ExpensesScreen extends ConsumerStatefulWidget {

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {

  var selectedCat = StateProvider((ref) => 'All',);
  var fromDate = StateProvider<DateTime?>((ref) => null,);
  var lastDate = StateProvider<DateTime?>((ref) => null,);
  var allExpenses = StateProvider((ref) => [],);
  var filteredExpenses = StateProvider((ref) => {},);
  var currencies = StateProvider((ref) => {},);


  final AuthService _authService = AuthService();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(milliseconds: 10), () {
      saveDeviceTokenToFirestore();
      getCurrencyRates();
      final expenseSnapshot = ref.watch(expenseStreamProvider);
      expenseSnapshot.when(
        data: (expenses) {
          if (expenses.isEmpty) {
            return const Center(child: Text('No expenses added yet.'));
          } else{
            groupByDate(expenses);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      );

    },);
  }

  void saveDeviceTokenToFirestore() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String userId = FirebaseAuth.instance.currentUser!.uid;

    // Retrieve the FCM token for the device
    String? fcmToken = await messaging.getToken();

    if (fcmToken != null) {
      // Save the FCM token to Firestore

      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);

      try {
        final docSnapshot = await docRef.get();
        // print("FCM Token: $fcmToken");

        if (docSnapshot.exists) {
          await docRef.update({
            'fcmToken': fcmToken, // Store the token under each user's document
          });
          if (kDebugMode) {
            print("FCM token updated successfully!");
          }
        } else {
          FirebaseFirestore.instance.collection('users').doc(userId).set({
            'fcmToken': fcmToken, // Store the token under each user's document
          });
          if (kDebugMode) {
            print("FCM token created successfully!");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error updating expense: $e");
        }
      }

    }
  }

  _applyFilters(){
    Map<String, List<Expense>> grouped = {};
    List expenses = ref.watch(allExpenses);
    var category = ref.watch(selectedCat);
    var _fromDate = ref.watch(fromDate);
    var _lastDate = ref.watch(lastDate);

    if (category.isNotEmpty && category != 'All') {
      expenses = expenses
          .where((expense) => expense.category == category)
          .toList();
    }

    if (_fromDate != null && _lastDate != null) {
      expenses = expenses.where((expense) {
        return (expense.date.isAfter(_fromDate) || expense.date.isAtSameMomentAs(_fromDate)) &&
            (expense.date.isBefore(_lastDate) || expense.date.isAtSameMomentAs(_lastDate));
      }).toList();
    }

    for (var expense in expenses) {
      String date = expense.date.toLocal().toString().split(' ')[0];
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(expense);
    }
    ref.read(filteredExpenses.notifier).state = grouped;

  }

  groupByDate(expenses){
    ref.read(allExpenses.notifier).state = expenses;
    Map<String, List<Expense>> grouped = {};
    var category = ref.watch(selectedCat);
    var _fromDate = ref.watch(fromDate);
    var _lastDate = ref.watch(lastDate);

    List _filteredExpenses = expenses;
    if (category.isNotEmpty && category != 'All') {
      _filteredExpenses = _filteredExpenses
          .where((expense) => expense.category == category)
          .toList();
    }

    if (_fromDate != null && _lastDate != null) {
      _filteredExpenses = _filteredExpenses.where((expense) {
        return (expense.date.isAfter(_fromDate) || expense.date.isAtSameMomentAs(_fromDate)) &&
            (expense.date.isBefore(_lastDate) || expense.date.isAtSameMomentAs(_lastDate));
      }).toList();
    }

    for (var expense in _filteredExpenses) {
      String date = expense.date.toLocal().toString().split(' ')[0];
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(expense);
    }
    ref.read(filteredExpenses.notifier).state = grouped;

    return grouped;

  }

  Future<void> deleteExpense(expenseId) async {
    await ExpenseService().deleteExpense(expenseId);
  }

  final allExpensesProvider = StateNotifierProvider<ExpenseNotifier, List<Expense>>((ref) {
    return ExpenseNotifier();
  });

  final expenseStreamProvider = StreamProvider<List<Expense>>((ref) {
    return ExpenseService().getExpenses();
  });


  // Fetch exchange rates and store in state
  final exchangeRatesProvider = StateProvider((ref) => ExchangeRateService(),);

  getCurrencyRates() async {
    ref.read(currencies.notifier).state = await ref.watch(exchangeRatesProvider).fetchExchangeRates();
  }


  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<Expense>>>(expenseStreamProvider, (previous, next) {
      next.whenData((expenses) {
        ref.read(allExpensesProvider.notifier).updateExpenses(expenses);
        ref.read(filteredExpenses.notifier).state = groupByDate(expenses);
        getCurrencyRates();
      });
    });
    var _currencies = ref.watch(currencies);
    var status = ref.watch(exchangeRatesProvider).status;
    var _filteredExpenses = ref.watch(filteredExpenses);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              await _authService.logOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FiltersWidget(
            selectedCategory: selectedCat,
            startDate: fromDate,
            applyFilters: _applyFilters,
            endDate: lastDate,
          ),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredExpenses.keys.length,
                  itemBuilder: (context, index) {
                    final date = _filteredExpenses.keys.elementAt(index);
                    final expenses = _filteredExpenses[date]!;
                    return Expenses(deleteExpense: deleteExpense, currencies: _currencies, date: date, expensesList: expenses,);
                  },
                ),
                if(_filteredExpenses.keys.isEmpty)const Center(child: Text('No expenses added yet.')),
                if(status == 'Initiated' || status == 'Loading')const Center(child: CircularProgressIndicator()),
                // if(status == 'Error')const Center(child: Text('Error occurred. Please try again after some time.'))
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}





class ExpenseNotifier extends StateNotifier<List<Expense>> {
  ExpenseNotifier() : super([]);

  void updateExpenses(List<Expense> newExpenses) {
    state = newExpenses;
  }
}