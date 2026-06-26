import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:banking_app/services/auth_service.dart';
import 'package:banking_app/services/transaction_service.dart';
import 'package:banking_app/models/user_model.dart';
import 'package:banking_app/models/transaction_model.dart';
import 'package:banking_app/widgets/bank_card.dart';
import 'package:banking_app/widgets/transaction_tile.dart';
import 'package:banking_app/screens/transactions/send_money_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final txService = TransactionService();
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: StreamBuilder<UserModel?>(
          stream: authService.streamUserData(uid),
          builder: (context, userSnap) {
            final user = userSnap.data;
            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bonjour 👋', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                            Text(user?.fullName ?? 'Chargement...',
                                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF2A2A4A)),
                          ),
                          child: const Icon(Icons.notifications_outlined, color: AppTheme.textPrimary, size: 22),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bank Card
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: BankCard(user: user),
                  ),
                ),

                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Actions rapides',
                            style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _QuickAction(icon: Icons.send_rounded, label: 'Envoyer', color: AppTheme.primary,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SendMoneyScreen()))),
                            _QuickAction(icon: Icons.download_rounded, label: 'Recevoir', color: AppTheme.accent),
                            _QuickAction(icon: Icons.swap_horiz_rounded, label: 'Virement', color: const Color(0xFFFF6B6B)),
                            _QuickAction(icon: Icons.more_horiz_rounded, label: 'Plus', color: AppTheme.warning),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Transactions récentes
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Transactions récentes',
                            style: TextStyle(color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('Voir tout', style: TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),

                StreamBuilder<List<TransactionModel>>(
                  stream: txService.streamTransactions(uid),
                  builder: (context, txSnap) {
                    final txs = txSnap.data?.take(5).toList() ?? [];
                    if (txs.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('Aucune transaction', style: TextStyle(color: AppTheme.textSecondary)),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                          child: TransactionTile(transaction: txs[i]),
                        ),
                        childCount: txs.length,
                      ),
                    );
                  },
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickAction({required this.icon, required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}
