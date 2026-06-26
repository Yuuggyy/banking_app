import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banking_app/utils/app_theme.dart';

class PinScreen extends StatefulWidget {
  final bool isVerify;
  const PinScreen({super.key, this.isVerify = false});

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String _message = 'Entrez votre nouveau PIN';

  void _onKey(String val) {
    if (_pin.length < 4) {
      setState(() => _pin += val);
      if (_pin.length == 4) {
        if (widget.isVerify) {
          _verifyPin();
        } else if (!_isConfirming) {
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {
              _confirmPin = _pin;
              _pin = '';
              _isConfirming = true;
              _message = 'Confirmez votre PIN';
            });
          });
        } else {
          _savePin();
        }
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _savePin() async {
    if (_pin != _confirmPin) {
      setState(() { _pin = ''; _message = 'PINs différents. Réessayez.'; });
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', _pin);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ PIN configuré !'), backgroundColor: AppTheme.success));
      Navigator.pop(context);
    }
  }

  Future<void> _verifyPin() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('user_pin');
    if (_pin == saved) {
      if (mounted) Navigator.pop(context, true);
    } else {
      setState(() { _pin = ''; _message = 'PIN incorrect. Réessayez.'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Code PIN', style: TextStyle(color: AppTheme.textPrimary)),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textPrimary), onPressed: () => Navigator.pop(context))),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text(_message, style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 32),
            // Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 18, height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < _pin.length ? AppTheme.primary : const Color(0xFF2A2A4A),
                  border: Border.all(color: i < _pin.length ? AppTheme.primary : AppTheme.textSecondary, width: 2),
                ),
              )),
            ),
            const Spacer(),
            // Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
              child: Column(
                children: [
                  for (var row in [['1','2','3'],['4','5','6'],['7','8','9'],['','0','⌫']])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: row.map((k) => _Key(k, onTap: () {
                          if (k == '⌫') _onDelete();
                          else if (k.isNotEmpty) _onKey(k);
                        })).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Key(this.label, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox(width: 72, height: 72);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72, height: 72,
        decoration: BoxDecoration(
          color: label == '⌫' ? AppTheme.error.withOpacity(0.15) : AppTheme.card,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF2A2A4A)),
        ),
        child: Center(
          child: Text(label, style: TextStyle(color: label == '⌫' ? AppTheme.error : AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
