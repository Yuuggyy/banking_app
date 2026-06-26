import 'package:flutter/material.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class ReceiptScreen extends StatelessWidget {
  final TransactionModel transaction;
  const ReceiptScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '\$', decimalDigits: 2);
    final isDebit = transaction.isDebit;
    final color = isDebit ? AppTheme.error : AppTheme.success;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Reçu de paiement', style: TextStyle(color: AppTheme.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(transaction.isSuccessful ? Icons.check_circle_outline : Icons.cancel_outlined, color: color, size: 44),
              ),
              const SizedBox(height: 16),
              Text(transaction.isSuccessful ? 'Transaction réussie' : 'Transaction échouée',
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(formatter.format(transaction.amount),
                  style: TextStyle(color: color, fontSize: 36, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              _ReceiptCard(transaction: transaction),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final TransactionModel transaction;
  const _ReceiptCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR').format(transaction.date);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF2A2A4A)),
      ),
      child: Column(
        children: [
          _Row('Référence', transaction.receiptId ?? transaction.id.substring(0, 8).toUpperCase()),
          const Divider(color: Color(0xFF2A2A4A), height: 24),
          _Row('Type', transaction.type.name.toUpperCase()),
          const SizedBox(height: 12),
          _Row('Date', dateStr),
          if (transaction.toAccount != null) ...[
            const SizedBox(height: 12),
            _Row('Destinataire', transaction.toAccount!),
          ],
          const SizedBox(height: 12),
          _Row('Statut', transaction.isSuccessful ? '✅ Succès' : '❌ Échoué'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
