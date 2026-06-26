import 'package:flutter/material.dart';
import 'package:banking_app/utils/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final Color? color;
  final bool outline;

  const CustomButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.color,
    this.outline = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: outline ? Colors.transparent : (color ?? AppTheme.primary),
          foregroundColor: Colors.white,
          side: outline ? BorderSide(color: color ?? AppTheme.primary, width: 1.5) : BorderSide.none,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: outline ? 0 : 4,
          shadowColor: AppTheme.primary.withOpacity(0.3),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      ),
    );
  }
}
