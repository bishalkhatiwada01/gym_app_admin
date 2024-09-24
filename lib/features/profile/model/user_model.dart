import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String? name;
  final String? profileImageUrl;
  final String token;
  final String username;

  UserModel({
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.token,
    required this.username,
  });

  factory UserModel.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      email: data['email'] ?? '',
      name: data['name'],
      profileImageUrl: data['profileImageUrl'],
      token: data['token'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
