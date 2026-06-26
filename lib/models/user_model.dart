class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String accountNumber;
  final double balance;
  final String cardType;
  final String profileImage;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.accountNumber,
    required this.balance,
    this.cardType = 'Visa',
    this.profileImage = '',
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      accountNumber: map['accountNumber'] ?? '',
      balance: (map['balance'] ?? 0.0).toDouble(),
      cardType: map['cardType'] ?? 'Visa',
      profileImage: map['profileImage'] ?? '',
      createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'accountNumber': accountNumber,
        'balance': balance,
        'cardType': cardType,
        'profileImage': profileImage,
        'createdAt': createdAt,
      };
}
