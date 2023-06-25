import 'dart:async';
import 'package:password_generator/views/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorePassword {
  StorePassword._privateConstructor();
  static final instance = StorePassword._privateConstructor();
  getList() async {
    final list =
        (await SharedPreferences.getInstance()).getStringList('passwordList') ??
            [];
    passwords.value.clear();
    passwords.value.addAll(list);
    passwords.notifyListeners();
  }

  // addList() async {
  //   (await SharedPreferences.getInstance()).setStringList(
  //       'passwordList', [...passwords.value, generatedPassword.value.text]);
  //   getList();
  // }

  // delete(String val) async {
  //   passwords.value.remove(val);
  //   (await SharedPreferences.getInstance())
  //       .setStringList('passwordList', passwords.value);
  //   getList();
  // }

  final StreamController<List<String>> _passwordList =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get passwordChanged => _passwordList.stream;

  void notifyChange() async {
    final data = (await supabase.from('passwords').select() as List);

    _passwordList.sink.add(data.map((e) => e['password'].toString()).toList());
  }
}
