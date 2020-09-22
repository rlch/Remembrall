import 'package:flutter/material.dart';
import 'package:remembrall/widgets/home.dart';
import 'package:remembrall/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.dark,
    home: Home(),
  ));
}
