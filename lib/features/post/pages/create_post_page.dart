// ignore_for_file: unused_result

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymappadmin/common/widgets/my_button.dart';
import 'package:gymappadmin/features/post/data/post_service.dart';
import 'package:gymappadmin/features/post/widgets/my_post_textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();

  String? postImageUrl;
  File? image;
  UploadTask? uploadTask;

  final TextEditingController postHeadlineController = TextEditingController();
  final TextEditingController postContentController = TextEditingController();
  final TextEditingController exercisesController = TextEditingController();
  final TextEditingController achievementsController = TextEditingController();
  final TextEditingController fitnessGoalsController = TextEditingController();

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle notification when app is in foreground
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification when app is opened from a terminated state
    });
  }

  Future<void> _uploadImage() async {
    if (image == null) return;

    final imageId = DateTime.now().toString();
    final ref = FirebaseStorage.instance.ref().child("post_images/$imageId");

    setState(() {
      uploadTask = ref.putFile(image!);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      postImageUrl = downloadUrl;
      uploadTask = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Upload image if selected
      if (image != null) {
        await _uploadImage();
      }

      // Get current userId
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      // Call the createPost method to save post data to Firestore
      final postDataSource = PostDataSource();
      final result = await postDataSource.createPost(
        postHeadline: postHeadlineController.text,
        postContent: postContentController.text,
        exercises: exercisesController.text.split(','),
        achievements: achievementsController.text.split(','),
        fitnessGoals: fitnessGoalsController.text.split(','),
        userId: userId, // Pass userId
        postImageUrl: postImageUrl,
      );

      if (result == 'Post Created') {
        ref.refresh(postProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post Created')),
        );
        Navigator.pop(context);
      } else {
        // Handle errors if post creation fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        title: const Text(
          'CREATE POST',
          style: TextStyle(
            letterSpacing: 4,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: postHeadlineController,
                  labelText: 'Headline',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 5,
                  controller: postContentController,
                  labelText: 'Content',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: exercisesController,
                  labelText: 'Exercises',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: achievementsController,
                  labelText: 'Achievements',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                MyPostTextField(
                  validator: _validateTextField,
                  maxlines: 1,
                  controller: fitnessGoalsController,
                  labelText: 'Fitness Goals',
                  obscureText: false,
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      final picture = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (picture != null) {
                        setState(() {
                          image = File(picture.path);
                        });
                      }
                    },
                    child: image == null
                        ? const CircleAvatar(
                            radius: 50,
                            child: Icon(
                              Icons.camera_alt,
                              size: 50,
                              color: Colors.black,
                            ),
                          )
                        : Image.file(
                            image!,
                            height: 350.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 10.h),
                if (uploadTask != null)
                  StreamBuilder<TaskSnapshot>(
                    stream: uploadTask!.snapshotEvents,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        double progress =
                            data.bytesTransferred / data.totalBytes;
                        return LinearProgressIndicator(value: progress);
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                SizedBox(height: 10.h),
                MyButton(
                  text: 'Post',
                  onTap: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
