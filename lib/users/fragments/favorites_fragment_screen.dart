import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/favorite.dart';
import 'package:clothes_app/users/userPreferenes/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class FavoriteFragmentScreen extends StatelessWidget {
  FavoriteFragmentScreen({super.key});
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Favorite>> getCurrentFavoriteList() async {
    //en son favorileri getirmeyi sağlayacaktık
    List<Favorite> favoriteListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readToFavorite), body: {
        'user_id': currentOnlineUser.user.user_id.toString(),
      });
      if (res.statusCode == 200) {
        var resBodyOfGetCurrentUserFavoriteListItems = jsonDecode(res.body);
        if (resBodyOfGetCurrentUserFavoriteListItems["success"] == true) {
          for (var eachCurrentUserCartItemData
              in resBodyOfGetCurrentUserFavoriteListItems[
                  'currentUserFavoriteData']) {
            favoriteListOfCurrentUser
                .add(Favorite.fromJson(eachCurrentUserCartItemData));
          }
        } else {
          Fluttertoast.showToast(msg: "Error occured");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (e) {
      print("Error:: $e");
    }
    return favoriteListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "My Favorite List: ",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "Order there best clothes for yourself now. ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          //displaying favorite list
        ],
      ),
    );
  }
}
