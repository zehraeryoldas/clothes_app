import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/items/item_detail_screen.dart';
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
    //mevcut kullanıcı favori öğe verileri olan verileri tutan listeyi kayıtlara döndürüyoruz.
    return favoriteListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "My Favorite List: ",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "Order there best clothes for yourself now. ",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          //displaying favorite list
          favoriteListItemDesignWidget(context)
        ],
      ),
    );
  }

  favoriteListItemDesignWidget(context) {
    return FutureBuilder(
        future: getCurrentFavoriteList(),
        builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (dataSnapShot.data == null) {
            return const Center(
              child: Text(
                "No favorite item found",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            );
          }
          if (dataSnapShot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: dataSnapShot.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Favorite eachFavoriteItemRecord = dataSnapShot.data![index];

                return GestureDetector(
                  onTap: () {
                    //Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      index == 0 ? 16 : 8,
                      16,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 6,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        //name + price
                        //tags
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //name and price
                                Row(
                                  children: [
                                    //name
                                    Expanded(
                                      child: Text(
                                        eachFavoriteItemRecord.name!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                    //price
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 12, right: 12),
                                      child: Text(
                                        "\$ ${eachFavoriteItemRecord.price}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.purpleAccent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 16,
                                ),

                                //tags
                                Text(
                                  "Tags: \n${eachFavoriteItemRecord.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //image clothes
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: FadeInImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder:
                                const AssetImage("images/place_holder.png"),
                            image: NetworkImage(
                              eachFavoriteItemRecord.image!,
                            ),
                            imageErrorBuilder:
                                (context, error, stackTraceError) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("Empty, No Data."),
            );
          }
        });
  }
}
