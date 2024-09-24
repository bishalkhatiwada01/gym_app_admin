// ignore_for_file: unused_result

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gymappadmin/common/widgets/my_button.dart';
import 'package:gymappadmin/features/post/data/post_data_model.dart';
import 'package:gymappadmin/features/post/data/post_service.dart';
import 'package:gymappadmin/features/post/widgets/my_post_textfield.dart';
import 'package:image_picker/image_picker.dart';

class EditPostPage extends ConsumerStatefulWidget {
  final PostDataModel postDataModel;

  const EditPostPage({
    super.key,
    required this.postDataModel,
  });

  @override
  ConsumerState<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends ConsumerState<EditPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _postService = PostDataSource();

  late TextEditingController postHeadlineController;
  late TextEditingController postContentController;
  late TextEditingController exercisesController;
  late TextEditingController achievementsController;
  late TextEditingController fitnessGoalsController;

  late String postImageUrl;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    postHeadlineController =
        TextEditingController(text: widget.postDataModel.postHeadline);
    postContentController =
        TextEditingController(text: widget.postDataModel.postContent);
    exercisesController =
        TextEditingController(text: widget.postDataModel.exercises.join(','));
    achievementsController = TextEditingController(
        text: widget.postDataModel.achievements.join(','));
    fitnessGoalsController = TextEditingController(
        text: widget.postDataModel.fitnessGoals.join(','));
    postImageUrl = widget.postDataModel.postImageUrl;
  }

  String? _validateTextField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Future<void> _updateImage() async {
    final picker = ImagePicker();
    final postImage = await picker.pickImage(source: ImageSource.gallery);

    if (postImage != null) {
      // Delete the old image from Firebase Storage
      if (postImageUrl.isNotEmpty) {
        Reference oldImageRef =
            FirebaseStorage.instance.refFromURL(postImageUrl);
        await oldImageRef.delete();
      }

      // Upload the new image to Firebase Storage
      final imageId = DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child('postImages/$imageId');
      await ref.putFile(File(postImage.path));
      final url = await ref.getDownloadURL();

      setState(() {
        selectedImage = File(postImage.path);
        postImageUrl = url;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      PostDataModel updatedPostData = PostDataModel(
        postId: widget.postDataModel.postId,
        postHeadline: postHeadlineController.text.trim(),
        postContent: postContentController.text.trim(),
        postImageUrl: postImageUrl,
        postCreatedAt: widget.postDataModel.postCreatedAt,
        exercises: exercisesController.text.trim().split(','),
        achievements: achievementsController.text.trim().split(','),
        fitnessGoals: fitnessGoalsController.text.trim().split(','),
        userId: widget.postDataModel.userId,
      );

      await _postService.updatePost(postDataModel: updatedPostData);
      ref.refresh(postProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post Updated')),
      );

      Navigator.pop(context);
      Navigator.pop(context);
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
          'EDIT POST',
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.h,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  child: selectedImage == null
                      ? Image.network(
                          postImageUrl,
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          selectedImage!,
                          height: 200.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                IconButton(
                  onPressed: _updateImage,
                  icon: const Icon(Icons.add_a_photo),
                ),
                SizedBox(height: 10.h),
                MyButton(
                  text: 'Update',
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
