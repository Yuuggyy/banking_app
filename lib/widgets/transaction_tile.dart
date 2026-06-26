import 'package:flutter/material.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionTile({super.key, required this.transaction, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDebit = transaction.isDebit;
    final color = isDebit ? AppTheme.error : AppTheme.success;
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '\$', decimalDigits: 2);
    final dateStr = DateFormat('d MMM, HH:mm', 'fr_FR').format(transaction.date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A4A)),
        ),
        child: Row(
          children: [
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(_txIcon(transaction.type), color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(transaction.title,
                      style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text(dateStr, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isDebit ? '-' : '+'}${formatter.format(transaction.amount)}',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: transaction.isSuccessful ? AppTheme.success.withOpacity(0.15) : AppTheme.error.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    transaction.isSuccessful ? 'Succès' : 'Échoué',
                    style: TextStyle(
                      color: transaction.isSuccessful ? AppTheme.success : AppTheme.error,
                      fontSize: 10, fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _txIcon(TransactionType t) {
    switch (t) {
      case TransactionType.sent: return Icons.arrow_upward_rounded;
      case TransactionType.received: return Icons.arrow_downward_rounded;
      case TransactionType.payment: return Icons.payment_rounded;
      case TransactionType.withdrawal: return Icons.atm_rounded;
      case TransactionType.deposit: return Icons.savings_rounded;
    }
  }
}
