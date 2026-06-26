import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get transactions stream
  Stream<List<TransactionModel>> streamTransactions(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => TransactionModel.fromMap(d.data()))
            .toList());
  }

  // Add transaction
  Future<String> addTransaction({
    required String uid,
    required TransactionModel transaction,
  }) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(transaction.id)
        .set(transaction.toMap());
    return transaction.id;
  }

  // Send money
  Future<void> sendMoney({
    required String senderUid,
    required String receiverAccount,
    required double amount,
    required String note,
  }) async {
    final batch = _db.batch();
    final txId = const Uuid().v4();
    final receiptId = 'RCP${DateTime.now().millisecondsSinceEpoch}';

    // Débit sender
    final senderTx = TransactionModel(
      id: txId,
      title: 'Virement envoyé',
      subtitle: note.isNotEmpty ? note : 'Vers $receiverAccount',
      amount: amount,
      type: TransactionType.sent,
      date: DateTime.now(),
      receiptId: receiptId,
      toAccount: receiverAccount,
    );

    final senderTxRef = _db
        .collection('users')
        .doc(senderUid)
        .collection('transactions')
        .doc(txId);
    batch.set(senderTxRef, senderTx.toMap());

    // Update sender balance
    final senderRef = _db.collection('users').doc(senderUid);
    batch.update(senderRef, {'balance': FieldValue.increment(-amount)});

    await batch.commit();
  }
}
