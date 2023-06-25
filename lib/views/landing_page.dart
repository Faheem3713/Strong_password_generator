import 'package:flutter/material.dart';

import 'auth/login.dart';
import 'auth/signup.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
                labelColor: Colors.black,
                tabs: [Tab(child: Text('Login')), Tab(child: Text('Sign up'))]),
          ),
          body: TabBarView(children: [LoginPage(), SignUp()]),
        ));
  }
}
