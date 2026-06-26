import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:banking_app/utils/app_theme.dart';
import 'package:banking_app/services/auth_service.dart';
import 'package:banking_app/models/user_model.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: const Text('QR Paiement', style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12)),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(10)),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondary,
                tabs: const [Tab(text: 'Mon QR'), Tab(text: 'Scanner')],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_MyQrTab(), _ScanTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyQrTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<UserModel?>(
      stream: AuthService().streamUserData(uid),
      builder: (context, snap) {
        final user = snap.data;
        final qrData = 'neobank://pay?account=${user?.accountNumber ?? uid}&name=${user?.fullName ?? ""}';
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.2), blurRadius: 24)],
                ),
                child: QrImageView(data: qrData, version: QrVersions.auto, size: 220, backgroundColor: Colors.white),
              ),
              const SizedBox(height: 24),
              Text(user?.fullName ?? '', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(user?.accountNumber ?? '', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14, letterSpacing: 2)),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text('Montrez ce QR code pour recevoir des paiements instantanément',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ScanTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(Icons.qr_code_scanner_rounded, color: AppTheme.primary, size: 60),
          ),
          const SizedBox(height: 24),
          const Text('Scanner un QR', style: TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Fonctionnalité disponible sur appareil réel', style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
