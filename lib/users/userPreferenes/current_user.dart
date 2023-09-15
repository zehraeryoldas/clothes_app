import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferenes/user_preferences.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class CurrentUser extends GetxController {
  User? currentUserInfo;
  // Mevcut kullanıcının verilerini yönetmek için GetxController sınıfını kullanıyoruz.

  final Rx<User> _currentUser = User(0, '', '', '').obs;
  // Rx<User> türünde bir değişken oluşturuyoruz. Bu değişken, kullanıcı verilerini içerecek.
  // .obs ile bu değişkenin değişikliklerini dinleyebilir hale getiriyoruz.

  User get user => _currentUser.value;
  // _currentUser değişkeninin değerine erişim sağlayan bir get metodu tanımlıyoruz.
  // Bu, mevcut kullanıcı verilerine erişmek için kullanılır.

  getUserInfo() async {
    // getUserInfo adında bir asenkron metot tanımlıyoruz.
    // Bu metot, kullanıcı bilgilerini almak için kullanılacak.

    User? getUserInfoFromLocalStorage =
        await RememberUserPreferences.readUserInfo();
    // RememberUserPreferences sınıfından kullanıcı bilgilerini alıyoruz. Bu işlem asenkron olduğu için await kullanıyoruz.
    // getUserInfoFromLocalStorage, kullanıcı bilgilerini içerir veya null olabilir.

    _currentUser.value = getUserInfoFromLocalStorage!;
    // _currentUser değişkenini, yerel depodan okunan kullanıcı bilgileriyle güncelliyoruz.
  }
}
