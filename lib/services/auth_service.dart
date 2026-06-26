import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:banking_app/models/user_model.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up
  Future<UserModel?> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user!;
      final accountNumber = _generateAccountNumber();
      final userModel = UserModel(
        uid: user.uid,
        fullName: fullName,
        email: email,
        phone: phone,
        accountNumber: accountNumber,
        balance: 0.0,
        createdAt: DateTime.now(),
      );
      await _db.collection('users').doc(user.uid).set(userModel.toMap());
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  // Sign In
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign Out
  Future<void> signOut() async => await _auth.signOut();

  // Get User Data
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) return UserModel.fromMap(doc.data()!);
    return null;
  }

  // Stream User Data
  Stream<UserModel?> streamUserData(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) return UserModel.fromMap(doc.data()!);
      return null;
    });
  }

  // Change Password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser!;
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
    await user.updatePassword(newPassword);
  }

  String _generateAccountNumber() {
    final uuid = const Uuid().v4().replaceAll('-', '');
    return uuid.substring(0, 10).toUpperCase();
  }
}
