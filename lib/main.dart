import 'dart:io';

import 'package:clothes_app/firebase_options.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_freagments.dart';
import 'package:clothes_app/users/userPreferenes/user_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb || Platform.isAndroid || Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

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
