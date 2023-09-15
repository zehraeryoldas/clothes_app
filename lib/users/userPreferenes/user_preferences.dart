import 'dart:convert';
import 'package:clothes_app/users/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPreferences {
  static Future<void> saveRememberUser(User userInfo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Kullanıcı bilgilerini JSON formatına dönüştürüyoruz
    String userJsonData = jsonEncode(userInfo.toJson());

    // JSON verisini "currentUser" adıyla SharedPreferences tercihlerine kaydediyoruz
    await sharedPreferences.setString("currentUser", userJsonData);
  }

  static Future<User?> readUserInfo() async {
    User? currentUserInfo;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // "currentUser" adıyla kaydedilmiş kullanıcı bilgileri metnini alıyoruz
    String? userInfo = sharedPreferences.getString("currentUser");

    if (userInfo != null) {
      // Eğer kayıtlı kullanıcı bilgileri varsa
      // JSON metnini bir (Map) olarak çözümlüyoruz
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);

      // Çözümlenen JSON verisini User.fromJson ile User sınıfına dönüştürüyoruz
      User currentUserInfo = User.fromJson(userDataMap);

      // Okunan kullanıcı bilgilerini döndürüyoruz
      return currentUserInfo;
    } else {
      // Eğer kayıtlı bilgi yoksa null döner
      return null;
    }
  }

  // Çıkış yaparak kullanıcı bilgilerini hafızadan kaldıracağız
  static Future<void> removeUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove("currentUser");
  }
}
