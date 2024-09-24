import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String userId;
  final double amount;
  final String transactionId;
  final DateTime paymentDate;

  Payment({
    required this.userId,
    required this.amount,
    required this.transactionId,
    required this.paymentDate,
  });

  factory Payment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Payment(
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      transactionId: data['transactionId'] ?? '',
      paymentDate: (data['paymentDate'] as Timestamp).toDate(),
    );
  }
}

class User {
  final String id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return User(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
    );
  }
}
