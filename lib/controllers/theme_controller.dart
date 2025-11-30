
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final box = GetStorage();
  final key ='isDarkMode';
  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  bool get _isDarkMode =>_loadTheme();

  bool _loadTheme()=> box.read(key) ?? false;

  void saveTheme(bool isDarkMode) => box.write(key,isDarkMode);

  void toggleTheme(){
    Future.delayed(const Duration(milliseconds: 50),(){
      Get.changeThemeMode(_loadTheme()? ThemeMode.light: ThemeMode.dark);
      saveTheme(!_loadTheme());
      update();
    });
  }
}