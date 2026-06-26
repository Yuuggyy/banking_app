import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:banking_app/services/transaction_service.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:banking_app/widgets/transaction_tile.dart';
import 'package:banking_app/screens/transactions/receipt_screen.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  TransactionType? _filter;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final txService = TransactionService();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                children: [
                  const Text('Historique', style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Icon(Icons.filter_list_rounded, color: AppTheme.textSecondary),
                ],
              ),
            ),
            // Filtres
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _FilterChip(label: 'Tout', selected: _filter == null, onTap: () => setState(() => _filter = null)),
                  _FilterChip(label: 'Envoyés', selected: _filter == TransactionType.sent, onTap: () => setState(() => _filter = TransactionType.sent)),
                  _FilterChip(label: 'Reçus', selected: _filter == TransactionType.received, onTap: () => setState(() => _filter = TransactionType.received)),
                  _FilterChip(label: 'Paiements', selected: _filter == TransactionType.payment, onTap: () => setState(() => _filter = TransactionType.payment)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: StreamBuilder<List<TransactionModel>>(
                stream: txService.streamTransactions(uid),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppTheme.primary));
                  }
                  var txs = snap.data ?? [];
                  if (_filter != null) txs = txs.where((t) => t.type == _filter).toList();
                  if (txs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long_outlined, color: AppTheme.textSecondary, size: 64),
                          const SizedBox(height: 16),
                          const Text('Aucune transaction', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
                        ],
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: txs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (ctx, i) => TransactionTile(
                      transaction: txs[i],
                      onTap: () => Navigator.push(ctx, MaterialPageRoute(
                        builder: (_) => ReceiptScreen(transaction: txs[i]),
                      )),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primary : AppTheme.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppTheme.primary : const Color(0xFF2A2A4A)),
        ),
        child: Text(label, style: TextStyle(color: selected ? Colors.white : AppTheme.textSecondary, fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }
}
