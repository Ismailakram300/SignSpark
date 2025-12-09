import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();
  final key = 'isDarkMode';

  ThemeMode get theme => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => box.read(key) ?? false;

  void saveTheme(bool value) => box.write(key, value);

  void toggleTheme(bool value) {
    saveTheme(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    update();
  }
}
