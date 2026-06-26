import 'package:flutter/material.dart';
import 'package:banking_app/models/user_model.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:intl/intl.dart';

class BankCard extends StatefulWidget {
  final UserModel? user;
  const BankCard({super.key, this.user});

  @override
  State<BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<BankCard> {
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    final balance = widget.user?.balance ?? 0.0;
    final formatter = NumberFormat.currency(locale: 'fr_FR', symbol: '\$', decimalDigits: 2);

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3A3090)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          // Cercles décoratifs
          Positioned(top: -30, right: -30, child: _circle(120, Colors.white.withOpacity(0.06))),
          Positioned(bottom: -40, left: -20, child: _circle(150, Colors.white.withOpacity(0.05))),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('NeoBank', style: TextStyle(color: Colors.white70, fontSize: 13, letterSpacing: 1)),
                    const Spacer(),
                    Text(widget.user?.cardType ?? 'Visa',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                  ],
                ),
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Solde disponible', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              _showBalance ? formatter.format(balance) : '•••••••',
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => _showBalance = !_showBalance),
                              child: Icon(_showBalance ? Icons.visibility : Icons.visibility_off,
                                  color: Colors.white60, size: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  widget.user?.accountNumber ?? '••••••••••',
                  style: const TextStyle(color: Colors.white60, fontSize: 13, letterSpacing: 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circle(double size, Color color) => Container(
    width: size, height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
