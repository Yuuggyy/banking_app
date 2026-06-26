import 'package:flutter/material.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:banking_app/services/auth_service.dart';
import 'package:banking_app/widgets/custom_button.dart';
import 'package:banking_app/widgets/custom_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;

  Future<void> _change() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await AuthService().changePassword(currentPassword: _currentCtrl.text.trim(), newPassword: _newCtrl.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Mot de passe modifié !'), backgroundColor: AppTheme.success));
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
      appBar: AppBar(title: const Text('Changer le mot de passe', style: TextStyle(color: AppTheme.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(controller: _currentCtrl, label: 'Mot de passe actuel', hint: '••••••••', icon: Icons.lock_outline, obscure: true,
                  validator: (v) => v!.isEmpty ? 'Requis' : null),
                const SizedBox(height: 16),
                CustomTextField(controller: _newCtrl, label: 'Nouveau mot de passe', hint: '••••••••', icon: Icons.lock_outline, obscure: true,
                  validator: (v) => v!.length < 6 ? 'Min. 6 caractères' : null),
                const SizedBox(height: 16),
                CustomTextField(controller: _confirmCtrl, label: 'Confirmer le mot de passe', hint: '••••••••', icon: Icons.lock_outline, obscure: true,
                  validator: (v) => v != _newCtrl.text ? 'Les mots de passe ne correspondent pas' : null),
                const SizedBox(height: 32),
                CustomButton(label: 'Confirmer', loading: _loading, onPressed: _change),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
