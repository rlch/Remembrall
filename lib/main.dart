import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remembrall/widgets/home.dart';
import 'package:remembrall/theme.dart';

void main() {
  runApp(Controller());
}

class Controller extends StatefulWidget {
  @override
  _ControllerState createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  AppTheme appTheme = AppTheme();

  @override
  void initState() {
    appTheme.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: appTheme.currentTheme(),
      home: ChangeNotifierProvider<AppTheme>.value(
        value: appTheme,
        child: Home(),
      ),
    );
  }
}
