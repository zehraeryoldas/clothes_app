import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class HomeFragmentScreen extends StatelessWidget {
  HomeFragmentScreen({super.key});

  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> getTrendingClothItems() async {
    List<Clothes> trendingClothItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.getTrendingMostPopularClothes));

      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          for (var eachRecord in responseBodyOfTrending["clothItemsData"]) {
            trendingClothItemsList.add(Clothes.fromJson(eachRecord));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: $errorMsg");
    }

    return trendingClothItemsList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          //search bar widget
          showSearchBarWidget(),
          const SizedBox(
            height: 26,
          ),
          //trending-popular items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Trending",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          ),
          trendingMostPopularClothItemWidget(context),
          const SizedBox(
            height: 24,
          ),
          //all new collections/items
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "New Collections",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 24),
            ),
          )
        ],
      ),
    );
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.purpleAccent,
            ),
          ),
          hintText: "Search best clothes here..",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.purpleAccent,
              )),
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.purpleAccent),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Colors.green),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
      ),
    );
  }

  Widget trendingMostPopularClothItemWidget(context) {
    return FutureBuilder(
      future: getTrendingClothItems(),
      builder: (context, AsyncSnapshot<List<Clothes>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (dataSnapshot.data == null) {
          return const Center(
            child: Text("No trending item found"),
          );
        }
        if (dataSnapshot.data!.isNotEmpty) {
          return SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapshot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                Clothes eachClothItemData = dataSnapshot.data![index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 200,
                    margin: EdgeInsets.fromLTRB(
                      index == 0 ? 16 : 8,
                      10,
                      index == dataSnapshot.data!.length - 1 ? 16 : 8,
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 3),
                          blurRadius: 6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        //item image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                          child: FadeInImage(
                            height: 150,
                            width: 200,
                            fit: BoxFit.cover,
                            placeholder: const AssetImage(
                                "assets/images/place_holder.png"),
                            image: NetworkImage(
                              eachClothItemData.image!,
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

                        //item name & price
                        //rating stars & rating numbers
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //item name & price
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      eachClothItemData.name!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    eachClothItemData.price.toString(),
                                    style: const TextStyle(
                                      color: Colors.purpleAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              //rating stars & rating numbers
                              Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: eachClothItemData.rating!,
                                    minRating: 1, //min star degree
                                    direction:
                                        Axis.horizontal, //yıldızların yönü
                                    allowHalfRating:
                                        true, //yarımlar gösterilsin mi
                                    itemCount: 5,

                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (value) {},
                                    ignoreGestures:
                                        true, //yıldızların üzeirne tyıklamayacağız sadece veritabanından gelen ratingf sayısını görüntüleyeceğiz
                                    unratedColor: Colors
                                        .grey, //derecelendirilmemiş yıldızların rengi
                                    itemSize: 20,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "(${eachClothItemData.rating})",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(
            child: Text("Empty, No data."),
          );
        }
      },
    );
  }
}
