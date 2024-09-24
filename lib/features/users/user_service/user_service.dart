import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymappadmin/features/payments/payment_model.dart';

final userListProvider = FutureProvider.autoDispose((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();
  return querySnapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
});
