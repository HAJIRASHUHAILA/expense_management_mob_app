import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/expense_model.dart';
import '../../home_screen/controller/home_controller.dart';

class TransactionController extends GetxController {
  final type = 'expense'.obs;
  final isSaving = false.obs;

  final name = TextEditingController();
  final amount = TextEditingController();
  final date = TextEditingController();
  final amountFocus = FocusNode();
  DateTime selectedDate = DateTime.now();

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];

  @override
  void onInit() {
    super.onInit();
    setDate(DateTime.now());
  }

  void setDate(DateTime d) {
    selectedDate = d;
    date.text =
    '${_days[d.weekday - 1]}, ${d.day} ${_months[d.month - 1]} ${d.year}';
  }

  void clearAmount() {
    amount.clear();
    amountFocus.requestFocus();
  }

  Future<void> save() async {
    final value =
    double.tryParse(amount.text.replaceAll(RegExp(r'[^0-9.]'), ''));

    if (name.text.trim().isEmpty || value == null || value <= 0) {
      Get.snackbar('Invalid input', 'Enter a name and a valid amount.',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isSaving.value = true;
    final ok = await Get.find<ExpenseController>().addExpense(
      Expense(
        title: name.text.trim(),
        amount: value,
        category: 'General',
        date: selectedDate.toIso8601String().substring(0, 10),
        type: type.value,
      ),
    );
    isSaving.value = false;

    if (ok) {
      Get.back();
    } else {
      Get.snackbar('Error', 'Could not save the transaction.',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void onClose() {
    name.dispose();
    amount.dispose();
    date.dispose();
    amountFocus.dispose();
    super.onClose();
  }
}