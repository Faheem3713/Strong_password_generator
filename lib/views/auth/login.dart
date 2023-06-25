import 'package:flutter/material.dart';
import 'package:password_generator/views/auth/signup.dart';
import 'package:password_generator/views/home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextField(
          controller: emailController,
          text: 'Email',
          validate: (val) {
            return null;
          },
        ),
        CustomTextField(
            controller: passwordController,
            isPassword: true,
            validate: (val) {
              return null;
            },
            text: 'Password'),
        FilledButton(
            onPressed: () async {
              await supabase.auth
                  .signInWithPassword(
                      password: passwordController.text,
                      email: emailController.text)
                  .then((value) {
                if (value.session?.user != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(),
                      ));
                }
              });
            },
            child: const Text('Login'))
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.validate,
    required this.text,
    this.isPassword = false,
    required this.controller,
  });
  final TextEditingController controller;
  final bool isPassword;
  final String? Function(String? val) validate;
  final String text;
  final ValueNotifier<bool> showPassword = ValueNotifier(true);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ValueListenableBuilder(
          valueListenable: showPassword,
          builder: (context, value, _) {
            return TextFormField(
              controller: controller,
              obscureText: isPassword ? value : false,
              validator: validate,
              decoration: InputDecoration(
                  hintText: text,
                  suffixIcon: IconButton(
                      onPressed: () {
                        showPassword.value = !showPassword.value;
                      },
                      icon: isPassword
                          ? Icon(
                              value ? Icons.visibility : Icons.visibility_off)
                          : const SizedBox())),
            );
          }),
    );
  }
}

class AuthValidate extends StatelessWidget {
  const AuthValidate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
