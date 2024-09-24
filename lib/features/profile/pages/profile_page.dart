import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymappadmin/common/widgets/my_drawer.dart';
import 'package:gymappadmin/features/auth/pages/login_page.dart';
import 'package:gymappadmin/features/profile/data/user_service.dart';
import 'package:gymappadmin/features/profile/widgets/my_card_profile.dart';

import 'package:share_plus/share_plus.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? _profileImage;
  String? _profileImageUrl;
  String? _userName;

  Future<String> userSignout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return "${e.message}";
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        _profileImage = imageFile;
      });
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final ref = FirebaseStorage.instance
        .ref()
        .child("profile_images/$userId/${DateTime.now().toString()}");

    try {
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() {
        _profileImageUrl = downloadUrl;
      });

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'profileImageUrl': downloadUrl,
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _updateUserName() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Change Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Enter new name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(nameController.text);
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (newName != null && newName.isNotEmpty) {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'name': newName,
        });
        setState(() {
          _userName = newName;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    ref.refresh(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    final userDataAsyncValue = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300]!,
        title: Text(
          "PROFILE",
          style: TextStyle(
            letterSpacing: 2,
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26.sp,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'change_name') {
                _updateUserName();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'change_name',
                  child: Text('Change Name'),
                ),
              ];
            },
            icon: Icon(
              Icons.more_vert,
              size: 24.sp,
              color: Colors.black,
            ),
          ),
        ],
      ),
      drawer: const MyDrawer(),
      backgroundColor: const Color.fromARGB(255, 230, 240, 255),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[300]!,
              Colors.purple[300]!,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          color: Colors.black,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  userDataAsyncValue.when(
                    data: (userData) {
                      return SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(height: 25.h),
                            GestureDetector(
                              onTap: _pickImage,
                              child: userData.profileImageUrl == null
                                  ? const CircleAvatar(
                                      radius: 60,
                                      backgroundImage:
                                          AssetImage("assets/no_image.jpg"),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(
                                        userData.profileImageUrl!,
                                      ),
                                    ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              userData.name ?? 'No name provided',
                              style: TextStyle(
                                  fontSize: 22.sp, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      AssetImage("assets/download.png"),
                                ),
                                SizedBox(width: 15),
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/GooglePlus-logo-red.png"),
                                ),
                                SizedBox(width: 15),
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/1_Twitter-new-icon-mobile-app.jpg"),
                                ),
                                SizedBox(width: 15),
                                CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/600px-LinkedIn_logo_initials.png"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const SizedBox(height: 16),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Column(
                                children: [
                                  SizedBox(height: 6.h),
                                  MyCardProfile(
                                    onPressed: () {},
                                    title: 'Payment History',
                                    leading: const Icon(
                                      Icons.history_edu,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  MyCardProfile(
                                    onPressed: () {
                                      Share.share('https://gymapp.com');
                                    },
                                    title: 'Invite a Friend',
                                    leading: const Icon(
                                      Icons.add_reaction_sharp,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  MyCardProfile(
                                    onPressed: () async {
                                      String result = await userSignout();
                                      if (result == "Success") {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()),
                                        );
                                      } else {
                                        if (kDebugMode) {
                                          print('Logout Failed');
                                        }
                                      }
                                    },
                                    title: 'Logout',
                                    leading: const Icon(
                                      Icons.logout,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                            SizedBox(height: 220.h),
                          ],
                        ),
                      );
                    },
                    error: (error, stackTrace) {
                      return Center(child: Text('Error: $error'));
                    },
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
