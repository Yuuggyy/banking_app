enum TransactionType { sent, received, payment, withdrawal, deposit }

class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? receiptId;
  final String? toAccount;
  final String? fromAccount;
  final bool isSuccessful;

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    required this.date,
    this.receiptId,
    this.toAccount,
    this.fromAccount,
    this.isSuccessful = true,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      type: TransactionType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => TransactionType.payment,
      ),
      date: map['date']?.toDate() ?? DateTime.now(),
      receiptId: map['receiptId'],
      toAccount: map['toAccount'],
      fromAccount: map['fromAccount'],
      isSuccessful: map['isSuccessful'] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'amount': amount,
        'type': type.name,
        'date': date,
        'receiptId': receiptId,
        'toAccount': toAccount,
        'fromAccount': fromAccount,
        'isSuccessful': isSuccessful,
      };

  bool get isDebit =>
      type == TransactionType.sent ||
      type == TransactionType.payment ||
      type == TransactionType.withdrawal;
}
