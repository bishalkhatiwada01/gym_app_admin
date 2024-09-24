import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gymappadmin/common/widgets/my_button.dart';
import 'package:gymappadmin/common/widgets/my_password_textfield.dart';
import 'package:gymappadmin/common/widgets/my_textfield.dart';
import 'package:gymappadmin/features/auth/data/auth_services.dart';
import 'package:gymappadmin/features/auth/data/status_page.dart';
import 'package:gymappadmin/features/auth/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();

  // text controller
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();

  Future<void> _register() async {
    await _authService.register(
      emailController.text,
      passwordController.text,
      usernameController.text,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const StatusPage()),
    );
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
            padding: EdgeInsets.symmetric(horizontal: 30.sp),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Icon
                  Icon(
                    Icons.fitness_center_sharp,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  Text(
                    'Lets Get Started!!',
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  SizedBox(height: 25.h),

                  // username textfield
                  MyTextField(
                    hintText: 'Username',
                    obscureText: false,
                    controller: usernameController,
                  ),
                  SizedBox(height: 10.h),

                  // email textfield
                  MyTextField(
                    hintText: 'Email',
                    obscureText: false,
                    controller: emailController,
                  ),
                  SizedBox(height: 10.h),

                  // password textfield

                  MyPasswordTextField(
                    hintText: 'Password',
                    obscureText: true,
                    controller: passwordController,
                  ),

                  SizedBox(height: 10.h),

                  // confirm password textfield
                  MyPasswordTextField(
                    hintText: 'Confirm Password',
                    obscureText: true,
                    controller: confirmPwController,
                  ),
                  SizedBox(height: 30.h),

                  // register button
                  MyButton(
                    text: 'Register',
                    onTap: _register,
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
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
                                  builder: (context) => const LoginPage()));
                        },
                        child: const Text('Login Here',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
