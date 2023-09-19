import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:flutter/material.dart';
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
        var resBodyOfTrending = jsonDecode(res.body);
        if (resBodyOfTrending['success'] == 'true') {
          for (var eachRecord in resBodyOfTrending["clothItemsData"]) {
            trendingClothItemsList.add(Clothes.fromJson(eachRecord));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Error,status code is not 200");
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
            fillColor: Colors.grey,
            filled: true),
      ),
    );
  }
}
