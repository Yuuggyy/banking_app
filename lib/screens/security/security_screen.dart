import 'package:flutter/material.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:banking_app/screens/security/change_password_screen.dart';
import 'package:banking_app/screens/security/pin_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _biometric = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Sécurité', style: TextStyle(color: AppTheme.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _SecurityItem(
              icon: Icons.lock_outline,
              title: 'Changer le mot de passe',
              subtitle: 'Modifiez votre mot de passe actuel',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
            ),
            const SizedBox(height: 12),
            _SecurityItem(
              icon: Icons.pin_outlined,
              title: 'Code PIN',
              subtitle: 'Configurer ou changer votre PIN à 4 chiffres',
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PinScreen())),
            ),
            const SizedBox(height: 12),
            _SecurityToggle(
              icon: Icons.fingerprint_rounded,
              title: 'Authentification biométrique',
              subtitle: 'Connexion rapide avec empreinte digitale',
              value: _biometric,
              onChanged: (v) => setState(() => _biometric = v),
            ),
            const SizedBox(height: 12),
            _SecurityToggle(
              icon: Icons.notifications_outlined,
              title: 'Alertes de sécurité',
              subtitle: 'Recevoir des notifications pour chaque transaction',
              value: _notifications,
              onChanged: (v) => setState(() => _notifications = v),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SecurityItem({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A2A4A))),
      child: Row(
        children: [
          Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: AppTheme.primary, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ])),
          const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
        ],
      ),
    ),
  );
}

class _SecurityToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;

  const _SecurityToggle({required this.icon, required this.title, required this.subtitle, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A2A4A))),
    child: Row(
      children: [
        Container(width: 46, height: 46, decoration: BoxDecoration(color: AppTheme.accent.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: AppTheme.accent, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ])),
        Switch(value: value, onChanged: onChanged, activeColor: AppTheme.accent),
      ],
    ),
  );
}
