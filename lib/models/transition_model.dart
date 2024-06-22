class Transaction {
  final String typeTransaction;
  final String title;
  final String note;
  final int value;
  final DateTime date;

  Transaction({
    required this.typeTransaction,
    required this.title,
    required this.note,
    required this.value,
    required this.date,
  });
}
