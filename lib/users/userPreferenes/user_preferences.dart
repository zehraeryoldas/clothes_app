import 'dart:convert';

import 'package:clothes_app/users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPreferences {
  static Future<void> saveRememberUser(User userInfo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userJsonData =
        jsonEncode(userInfo.toJson()); //verileri json formatında iletiyoruz.
    await sharedPreferences.setString("currentUser",
        userJsonData); //currentUser adıyla paylaşılan tercihleri kullanarak telefonun yerel depolama alanına sunuyoruz
  }
}
