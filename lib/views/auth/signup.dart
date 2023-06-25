import 'package:flutter/material.dart';
import 'package:password_generator/views/auth/login.dart';
import 'package:password_generator/views/home.dart';
import 'package:password_generator/views/widgets/custom_button.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
                validate: (val) {
                  if (val == null || val.isEmpty) {
                    return 'field cannot be empty';
                  } else {
                    return null;
                  }
                },
                text: 'Email',
                controller: emailController),
            CustomTextField(
                isPassword: true,
                validate: (val) {
                  if (val == null || val.isEmpty) {
                    return 'field cannot be empty';
                  } else {
                    return null;
                  }
                },
                text: 'Password',
                controller: passwordController),
            CustomTextField(
                isPassword: true,
                validate: (val) {
                  if (val == null || val.isEmpty) {
                    return 'field cannot be empty';
                  } else {
                    return null;
                  }
                },
                text: 'Confirm Password',
                controller: confirmPasswordController),
            CustomButton(
                text: 'Sign In',
                onPressed: () async {
                  if (_key.currentState!.validate() ||
                      passwordController.text ==
                          confirmPasswordController.text) {
                    await supabase.auth
                        .signUp(
                            password: passwordController.text,
                            email: emailController.text)
                        .then((value) {
                      if (value.session?.user != null) {
                        return Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyHomePage(),
                            ));
                      }
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Something went wrong')));
                  }
                })
          ],
        ),
      ),
    );
  }
}
