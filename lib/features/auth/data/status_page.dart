import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gymappadmin/features/auth/pages/login_page.dart';
import 'package:gymappadmin/main.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return MainPage();
          } else {
            return const LoginPage();
          }

          // user is not logged in
        },
      ),
    );
  }
}
