import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:banking_app/services/auth_service.dart';
import 'package:banking_app/models/user_model.dart';
import 'package:banking_app/screens/security/security_screen.dart';
import 'package:banking_app/screens/auth/login_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: StreamBuilder<UserModel?>(
          stream: AuthService().streamUserData(uid),
          builder: (context, snap) {
            final user = snap.data;
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Avatar
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppTheme.primary, AppTheme.accent]),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            (user?.fullName ?? 'U').substring(0, 1).toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(user?.fullName ?? '...', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(user?.email ?? '', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                        child: Text(user?.accountNumber ?? '', style: const TextStyle(color: AppTheme.primary, fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        _SectionTitle('Mon compte'),
                        _MenuItem(icon: Icons.person_outline, label: 'Informations personnelles', onTap: () {}),
                        _MenuItem(icon: Icons.credit_card_outlined, label: 'Mes cartes', onTap: () {}),
                        _MenuItem(icon: Icons.history_rounded, label: 'Historique', onTap: () {}),
                        const SizedBox(height: 16),
                        _SectionTitle('Sécurité'),
                        _MenuItem(icon: Icons.security_rounded, label: 'Paramètres de sécurité',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen()))),
                        const SizedBox(height: 16),
                        _SectionTitle('Application'),
                        _MenuItem(icon: Icons.help_outline_rounded, label: 'Aide & Support', onTap: () {}),
                        _MenuItem(icon: Icons.info_outline_rounded, label: 'À propos', onTap: () {}),
                        const SizedBox(height: 8),
                        _MenuItem(
                          icon: Icons.logout_rounded,
                          label: 'Se déconnecter',
                          color: AppTheme.error,
                          onTap: () async {
                            await AuthService().signOut();
                            if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Align(alignment: Alignment.centerLeft,
      child: Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 1))),
  );
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textPrimary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF2A2A4A))),
        child: Row(
          children: [
            Icon(icon, color: c, size: 20),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: TextStyle(color: c, fontSize: 14, fontWeight: FontWeight.w500))),
            Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
