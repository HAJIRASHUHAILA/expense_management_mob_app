import 'package:get/get.dart';

import '../../../database/database_helper.dart';
import '../../../models/expense_model.dart';

class ExpenseController extends GetxController {
  final DatabaseHelper _database = DatabaseHelper.instance;

  final expenses = <Expense>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  double get totalIncome => expenses
      .where((e) => e.isIncome)
      .fold(0.0, (sum, e) => sum + e.amount);

  double get totalExpense => expenses
      .where((e) => !e.isIncome)
      .fold(0.0, (sum, e) => sum + e.amount);

  double get balance => totalIncome - totalExpense;

  /// Expenses in the last 7 days.
  double get weeklyExpense {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return expenses.where((e) {
      if (e.isIncome) return false;
      final d = DateTime.tryParse(e.date);
      return d != null && d.isAfter(cutoff);
    }).fold(0.0, (sum, e) => sum + e.amount);
  }

  double get dailyAverage => weeklyExpense / 7;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final records = await _database.getExpenses();
      expenses.assignAll(records);
    } catch (e) {
      errorMessage.value = 'Could not load expenses.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addExpense(Expense expense) async {
    try {
      await _database.insertExpense(expense);
      await loadExpenses();
      return true;
    } catch (e) {
      errorMessage.value = 'Could not save expense.';
      return false;
    }
  }

  Future<bool> updateExpense(Expense expense) async {
    try {
      await _database.updateExpense(expense);
      await loadExpenses();
      return true;
    } catch (e) {
      errorMessage.value = 'Could not update expense.';
      return false;
    }
  }

  Future<bool> deleteExpense(int id) async {
    try {
      await _database.deleteExpense(id);
      await loadExpenses();
      return true;
    } catch (e) {
      errorMessage.value = 'Could not delete expense.';
      return false;
    }
  }
}