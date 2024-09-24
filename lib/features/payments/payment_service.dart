import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymappadmin/features/payments/payment_model.dart';

final firebaseServiceProvider = Provider((ref) => FirebaseService());

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getPaymentHistory() async {
    QuerySnapshot paymentSnapshot = await _firestore
        .collection('payments')
        .orderBy('paymentDate', descending: true)
        .get();

    List<Map<String, dynamic>> paymentHistory = [];

    for (var doc in paymentSnapshot.docs) {
      Payment payment = Payment.fromFirestore(doc);
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(payment.userId).get();
      User user = User.fromFirestore(userDoc);

      paymentHistory.add({
        'payment': payment,
        'user': user,
      });
    }

    return paymentHistory;
  }
}

final paymentHistoryProvider = FutureProvider.autoDispose((ref) async {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return await firebaseService.getPaymentHistory();
});
