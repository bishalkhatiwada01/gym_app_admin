class PostDataModel {
  String postId;
  String postHeadline; // e.g., "My latest progress!"
  String postContent; // e.g., "Here’s a snapshot of my current physique."
  String postImageUrl; // URL of the image showing body update
  String postCreatedAt; // Timestamp of the post
  List<String> exercises; // Exercises performed or related to the update
  List<String> achievements; // Achievements or milestones reached
  List<String> fitnessGoals; // Goals that this post relates to

  String userId;

  PostDataModel({
    required this.postId,
    required this.postHeadline,
    required this.postContent,
    required this.postImageUrl,
    required this.postCreatedAt,
    required this.exercises,
    required this.achievements,
    required this.fitnessGoals,
    required this.userId,
  });

  factory PostDataModel.fromJson(Map<String, dynamic> json) {
    return PostDataModel(
      postId: json['postId'],
      postHeadline: json['postHeadline'],
      postContent: json['postContent'],
      postImageUrl: json['postImageUrl'],
      postCreatedAt: json['postCreatedAt'],
      exercises: List<String>.from(json['exercises']),
      achievements: List<String>.from(json['achievements']),
      fitnessGoals: List<String>.from(json['fitnessGoals']),
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'postHeadline': postHeadline,
      'postContent': postContent,
      'postImageUrl': postImageUrl,
      'postCreatedAt': postCreatedAt,
      'exercises': exercises,
      'achievements': achievements,
      'fitnessGoals': fitnessGoals,
      'userId': userId,
    };
  }
}
