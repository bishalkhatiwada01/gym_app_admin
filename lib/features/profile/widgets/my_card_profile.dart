import 'package:flutter/material.dart';

class MyCardProfile extends StatelessWidget {
  final String title;
  final Widget leading;
  final VoidCallback onPressed;

  const MyCardProfile({
    super.key,
    required this.title,
    required this.leading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[100]!,
              Colors.purple[100]!,
            ],
          ),
        ),
        child: ListTile(
          leading: const Icon(
            Icons.privacy_tip_sharp,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.white,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
