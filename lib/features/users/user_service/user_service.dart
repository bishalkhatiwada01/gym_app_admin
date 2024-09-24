import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymappadmin/features/payments/payment_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

final userListProvider = FutureProvider.autoDispose((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();
  return querySnapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
});

class UpdateUserService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUser(String userId, Map<String, dynamic> userData) async {
    try {
      // Update user data in Firestore
      await _firestore.collection('users').doc(userId).update(userData);

      // If the email is being updated, update it in Firebase Auth as well
      if (userData.containsKey('email')) {
        await _auth.currentUser?.updateEmail(userData['email']);
      }

      // If the name is being updated, update the display name in Firebase Auth
      if (userData.containsKey('name')) {
        await _auth.currentUser?.updateDisplayName(userData['name']);
      }
    } catch (e) {
      print('Error updating user: $e');
      throw e;
    }
  }
}

final updateUserServiceProvider = Provider<UpdateUserService>((ref) {
  return UpdateUserService();
});

class PaymentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteUser(String userId) async {
    try {
      // Delete the user document from Firestore (adjust path if needed)
      await _firestore.collection('users').doc(userId).delete();
      // Optionally, handle cascading deletes (e.g., user payments or related data)
      await _deleteUserPayments(userId);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<void> _deleteUserPayments(String userId) async {
    final payments = await _firestore
        .collection('payments')
        .where('userId', isEqualTo: userId)
        .get();

    for (var doc in payments.docs) {
      await doc.reference.delete();
    }
  }
}

// Define a provider for PaymentService
final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

// Add a provider for deleting a user
final deleteUserProvider =
    FutureProvider.family<void, String>((ref, userId) async {
  final paymentService = ref.read(paymentServiceProvider);
  await paymentService.deleteUser(userId);
});
