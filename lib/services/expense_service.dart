import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addExpense(Expense expense) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .add(expense.toMap());
  }

  Stream<List<Expense>> getExpenses() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => Expense.fromMap(doc.data(), doc.id)).toList());
  }

  // Update an existing expense
  Future<void> updateExpense(Expense expense) async {

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expense.id) // Use the expense ID to find the correct document
        .update(expense.toMap());
  }

  Future<void> deleteExpense(String expenseId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }
}
