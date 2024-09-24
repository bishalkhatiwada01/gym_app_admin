import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymappadmin/features/profile/model/user_model.dart';

final userProvider = FutureProvider.autoDispose<UserModel>((ref) async {
  final userService = UserService();
  return userService.getUserDetails();
});

final userByIdProvider =
    FutureProvider.family<UserModel, String>((ref, userId) {
  return UserService().getUserById(userId);
});

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch details of the currently logged-in user
  Future<UserModel> getUserDetails() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc =
          await _firestore.collection('admin_users').doc(user.uid).get();
      return UserModel.fromDocument(doc);
    } else {
      throw Exception('No current user');
    }
  }

  // Fetch details of any user by their userId
  Future<UserModel> getUserById(String userId) async {
    try {
      // Fetch user data from Firestore by userId
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      } else {
        throw Exception('User not found');
      }
    } catch (e) {
      throw Exception('Error fetching user data: $e');
    }
  }
}
