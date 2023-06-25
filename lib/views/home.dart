// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_generator/views/functions/get_password.dart';
import 'package:password_generator/views/functions/store_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

ValueNotifier<List<String>> passwords = ValueNotifier([]);
final supabase = Supabase.instance.client;

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final ValueNotifier<Map<String, bool>> passwordValues = ValueNotifier({
    'Lowercase': false,
    'Uppercase': false,
    'Characters': false,
    'Numbers': false
  });

  final ValueNotifier<PasswordTypes?> selectedType =
      ValueNotifier(PasswordTypes.easy);
  final lengthController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    StorePassword.instance.notifyChange();
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          children: [
            ...passwordValues.value.keys.map((e) {
              return ValueListenableBuilder(
                  valueListenable: passwordValues,
                  builder: (context, checkData, _) {
                    return CheckboxListTile(
                      onChanged: (value) {
                        passwordValues.value[e] = value!;
                        passwordValues.notifyListeners();
                        selectedType.value = null;
                      },
                      title: Text(e),
                      value: checkData[e],
                    );
                  });
            }).toList(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                radioButtonWidget(type: PasswordTypes.easy, text: 'Easy'),
                radioButtonWidget(type: PasswordTypes.average, text: 'Avarage'),
                radioButtonWidget(type: PasswordTypes.strong, text: 'Strong')
              ],
            ),
            customTextField(
                validator: (val) {
                  return val == null || val.isEmpty
                      ? 'Enter a valid length'
                      : int.parse(val) < 8
                          ? 'Length cannot be lessthan 8'
                          : null;
                },
                context: context,
                isCopy: false,
                controller: lengthController,
                hint: 'Enter your passworrd length'),
            customTextField(
                controller: generatedPassword.value,
                hint: '',
                context: context),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                      onPressed: () async {
                        await supabase.from('passwords').insert({
                          'password': generatedPassword.value.text
                        }).whenComplete(() {
                          log('hello');
                        }).catchError((e) {
                          log(e.toString());
                          return const SizedBox();
                        });
                        StorePassword.instance.notifyChange();
                      },
                      child: const Text('Add')),
                ),
                Expanded(
                  child: FilledButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          _onGenerate();
                        }
                      },
                      child: const Text('Generate password')),
                ),
              ],
            ),
            StreamBuilder(
              stream: StorePassword.instance.passwordChanged,
              builder: (context, value) {
                if (value.hasData) {
                  return ListView.builder(
                    itemCount: value.data!.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(value.data![index]),
                    ),
                  );
                } else {
                  return const Text('Error');
                }
              },
            )
          ],
        ),
      ),
    );
  }

  _onGenerate() {
    selectedType.value == null
        ? GeneratorData.instance.generatePassword(
            lowercase: passwordValues.value['Lowercase']!,
            uppercase: passwordValues.value['Uppercase']!,
            numbers: passwordValues.value['Numbers']!,
            characters: passwordValues.value['Characters']!,
            length: int.parse(lengthController.text))
        : selectedType.value == PasswordTypes.easy
            ? GeneratorData.instance.generatePassword(
                length: int.parse(lengthController.text), lowercase: true)
            : selectedType.value == PasswordTypes.average
                ? GeneratorData.instance.generatePassword(
                    length: int.parse(lengthController.text),
                    lowercase: true,
                    uppercase: true)
                : GeneratorData.instance.generatePassword(
                    length: int.parse(lengthController.text),
                    characters: true,
                    uppercase: true,
                    lowercase: true,
                    numbers: true);
  }

  Padding customTextField(
      {required TextEditingController controller,
      required String hint,
      bool isCopy = true,
      String? Function(String?)? validator,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            suffixIcon: !isCopy
                ? null
                : IconButton(
                    icon: const Icon(Icons.copy),
                    onPressed: !isCopy
                        ? null
                        : () {
                            Clipboard.setData(ClipboardData(
                                text: generatedPassword.value.text));
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                  content: Text('Copied to clipboard')));
                          },
                  )),
      ),
    );
  }

  Widget radioButtonWidget(
      {required PasswordTypes type, required String text}) {
    return ValueListenableBuilder(
        valueListenable: selectedType,
        builder: (context, val, _) {
          return Row(
            children: [
              Radio(
                toggleable: true,
                value: type,
                groupValue: val,
                onChanged: (value) {
                  selectedType.value = value == val ? null : value;
                  passwordValues.value.updateAll((key, value) => value = false);
                  passwordValues.notifyListeners();
                },
              ),
              Text(text)
            ],
          );
        });
  }
}

enum PasswordTypes { easy, average, strong }
