import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymappadmin/features/post/data/post_data_model.dart';

final postProvider = FutureProvider<List<PostDataModel>>(
  (ref) => PostDataSource().getAllPosts(),
);

class PostDataSource {
  final postDb = FirebaseFirestore.instance.collection('posts');

  Future<String> createPost({
    required String postHeadline,
    required String postContent,
    required List<String> exercises,
    required List<String> achievements,
    required List<String> fitnessGoals,
    required String userId, // Add userId
    String? postImageUrl,
  }) async {
    try {
      final postId = postDb.doc().id; // Generate postId

      await postDb.doc(postId).set({
        'postId': postId, // Include postId
        'userId': userId, // Include userId
        'postHeadline': postHeadline,
        'postContent': postContent,
        'postImageUrl': postImageUrl,
        'postCreatedAt': DateTime.now().toIso8601String(),
        'exercises': exercises,
        'achievements': achievements,
        'fitnessGoals': fitnessGoals,
      });

      return 'Post Created';
    } on FirebaseException catch (err) {
      return '${err.message}';
    }
  }

  Future<List<PostDataModel>> getAllPosts() async {
    try {
      final querySnapshot = await postDb.get();

      return querySnapshot.docs
          .map((doc) => PostDataModel.fromJson({
                // ignore: unnecessary_cast
                ...doc.data() as Map<String, dynamic>,
                'postId': doc.id,
              }))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updatePost({
    required PostDataModel postDataModel,
  }) async {
    try {
      await postDb.doc(postDataModel.postId).update({
        'postHeadline': postDataModel.postHeadline,
        'postContent': postDataModel.postContent,
        'postImageUrl': postDataModel.postImageUrl,
        'postCreatedAt': DateTime.now().toIso8601String(),
        'exercises': postDataModel.exercises,
        'achievements': postDataModel.achievements,
        'fitnessGoals': postDataModel.fitnessGoals,
      });

      return 'Post Updated';
    } on FirebaseException catch (err) {
      return '${err.message}';
    }
  }
}

void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
