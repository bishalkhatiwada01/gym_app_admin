// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymappadmin/common/widgets/my_drawer.dart';
import 'package:gymappadmin/features/post/data/post_service.dart';
import 'package:gymappadmin/features/post/pages/create_post_page.dart';
import 'package:gymappadmin/features/post/widgets/my_post_card.dart';
import 'package:gymappadmin/features/profile/data/user_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final postData = ref.watch(postProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300]!,
        title: Text(
          "POSTS",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26.sp,
            letterSpacing: 2,
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
      ),
      drawer: MyDrawer(),
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
        child: postData.when(
          data: (data) {
            return data.isEmpty
                ? Center(
                    child: Text(
                    'No Posts',
                    style: TextStyle(fontSize: 20.sp),
                  ))
                : RefreshIndicator(
                    onRefresh: () async {
                      ref.refresh(postProvider);
                      ref.refresh(userProvider);
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return PostCard(
                          postData: data[index],
                        );
                      },
                      itemCount: data.length,
                    ),
                  );
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreatePostPage(),
              ));
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.sp),
          side: const BorderSide(width: 4),
        ),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          size: 30.w,
          color: Colors.black,
        ),
      ),
    );
  }
}
