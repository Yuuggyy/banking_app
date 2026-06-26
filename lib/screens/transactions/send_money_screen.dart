import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:banking_app/services/transaction_service.dart';
import 'package:banking_app/widgets/custom_button.dart';
import 'package:banking_app/widgets/custom_text_field.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await TransactionService().sendMoney(
        senderUid: uid,
        receiverAccount: _accountCtrl.text.trim(),
        amount: double.parse(_amountCtrl.text.trim()),
        note: _noteCtrl.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Virement effectué !'), backgroundColor: AppTheme.success));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur : $e'), backgroundColor: AppTheme.error));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Envoyer de l\'argent', style: TextStyle(color: AppTheme.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(controller: _accountCtrl, label: 'Numéro de compte destinataire', hint: 'Ex: AB12CD3456', icon: Icons.account_circle_outlined,
                  validator: (v) => v!.isEmpty ? 'Requis' : null),
                const SizedBox(height: 16),
                CustomTextField(controller: _amountCtrl, label: 'Montant (\$)', hint: '0.00', icon: Icons.attach_money_rounded,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v!.isEmpty) return 'Requis';
                    final n = double.tryParse(v);
                    if (n == null || n <= 0) return 'Montant invalide';
                    return null;
                  }),
                const SizedBox(height: 16),
                CustomTextField(controller: _noteCtrl, label: 'Note (optionnel)', hint: 'Loyer, Remboursement...', icon: Icons.note_outlined),
                const SizedBox(height: 32),
                CustomButton(label: 'Envoyer', loading: _loading, onPressed: _send),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
