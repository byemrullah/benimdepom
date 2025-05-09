class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final String description;
  final String category; // Gelir veya Gider kategorisi

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
    required this.category,
  });
}