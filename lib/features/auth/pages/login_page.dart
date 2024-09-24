import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymappadmin/common/widgets/my_button.dart';
import 'package:gymappadmin/common/widgets/my_password_textfield.dart';
import 'package:gymappadmin/common/widgets/my_textfield.dart';
import 'package:gymappadmin/features/auth/data/auth_services.dart';
import 'package:gymappadmin/features/auth/data/status_page.dart';
import 'package:gymappadmin/features/auth/pages/forgot_password_page.dart';

import 'package:gymappadmin/features/auth/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final formKey = GlobalKey<FormState>();

  // text controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _login() async {
    await _authService.login(
      emailController.text,
      passwordController.text,
    );

    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const StatusPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 230, 240, 255),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[200]!,
              Colors.purple[200]!,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(25.sp),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fitness_center_sharp,
                      size: 80,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    Text(
                      'Welcome Back to FITNESS APP!!',
                      style: TextStyle(
                        fontSize: 20.sp,
                      ),
                    ),
                    SizedBox(height: 45.h),
                    MyTextField(
                      hintText: 'Email',
                      obscureText: false,
                      controller: emailController,
                    ),
                    SizedBox(height: 25.h),
                    MyPasswordTextField(
                      hintText: 'Password',
                      obscureText: true,
                      controller: passwordController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    MyButton(
                      text: 'Login',
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          await _login();
                        }
                      },
                    ),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Dont have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterPage()));
                          },
                          child: const Text('Register Here',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
