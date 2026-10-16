class Expense {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final String date;
  final String description;
  final String type; // 'expense' or 'income'

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description = '',
    this.type = 'expense',
  });

  bool get isIncome => type == 'income';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'description': description,
      'type': type,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      category: map['category'] as String,
      date: map['date'] as String,
      description: map['description'] as String? ?? '',
      type: map['type'] as String? ?? 'expense',
    );
  }
}