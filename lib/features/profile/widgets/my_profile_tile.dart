// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfileListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const MyProfileListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 5.w),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
            )),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 20.0,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
