import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:password_generator/views/functions/store_password.dart';
import 'package:password_generator/views/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'views/landing_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Supabase.initialize(
        url: "https://lnxoromlogmyevmfohoa.supabase.co",
        anonKey:
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxueG9yb21sb2dteWV2bWZvaG9hIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODcyNjkzMjYsImV4cCI6MjAwMjg0NTMyNn0.8oOHxIgZlGguMDEFLYUqrQY24vBlSu-o9rMylDffxSI");
  } catch (e) {
    log(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    StorePassword.instance.getList();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LandingPage(),
    );
  }
}
