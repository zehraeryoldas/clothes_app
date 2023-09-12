import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_freagments.dart';
import 'package:clothes_app/users/userPreferenes/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const LoginScreen();
          } else {
            return DashBoardOfFragments();
          }
        },
        future: RememberUserPreferences.readUserInfo(),
      ),
    );
  }
}
