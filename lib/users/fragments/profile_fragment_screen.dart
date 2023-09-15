import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/userPreferenes/current_user.dart';
import 'package:clothes_app/users/userPreferenes/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class ProfileFragmentScreen extends StatelessWidget {
  ProfileFragmentScreen({super.key});

//kullanıcının name ve emailini currentuserdan aldık aşko
  final CurrentUser _currentUser = Get.put(CurrentUser());

  signOutUser() async {
    var resultResponse = await Get.dialog(AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text(
        "Log out",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: const Text("Are you sure?\nyou want to logout from app?"),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            )),
        TextButton(
            onPressed: () {
              Get.back(result: "LoggedOut");
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.black),
            )),
      ],
    ));
    if (resultResponse == "LoggedOut") {
      //delete-remove the user data from phone local storage
      RememberUserPreferences.removeUserInfo().then((value) {
        Get.off(const LoginScreen());
      });
    }
  }

  Widget userInfoItemPRofile(IconData iconData, String userData) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.grey),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 30,
            color: Colors.black,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Text(
            userData,
            style: const TextStyle(fontSize: 15),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Center(
            child: Image.asset(
              "assets/images/man.png",
              width: 240,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          userInfoItemPRofile(Icons.person, _currentUser.user.user_name),
          const SizedBox(
            height: 20,
          ),
          userInfoItemPRofile(Icons.email, _currentUser.user.user_email),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Material(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () {
                  signOutUser();
                },
                borderRadius: BorderRadius.circular(32),
                child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    child: Text(
                      "Sign Out",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
