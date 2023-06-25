import 'package:flutter/material.dart';

class GeneratorData {
  GeneratorData._privateConstructor();
  static final instance = GeneratorData._privateConstructor();
  void generatePassword(
      {bool lowercase = false,
      bool uppercase = false,
      bool numbers = false,
      bool characters = false,
      required int length}) {
    const letterLowerCase = "abcdefghijklmnopqrstuvwxyz";
    const letterUpperCase = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    const number = '0123456789';
    const special = '@#%^*>\$@?/[]=+';
    String char = '';
    if (lowercase) char += letterLowerCase;
    if (uppercase) char += letterUpperCase;
    if (numbers) char += number;
    if (characters) char += special;
    final generated = char.split('');
    generated.shuffle();

    generatedPassword.value.text = generated.sublist(0, length).join('');
  }
}

ValueNotifier<TextEditingController> generatedPassword =
    ValueNotifier(TextEditingController());
