import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasky/services/notification_seervices.dart';
import 'package:tasky/services/theme_services.dart';
import 'package:tasky/ui/pages/home_screen.dart';
import 'package:tasky/ui/pages/notification_screen.dart';
import 'package:tasky/ui/theme.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  // NotifyHelper().initializNotification();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      // ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      home: const HomeScreen(),
    );
  }
}
