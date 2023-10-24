import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/cart/cart_list_screen.dart';
import 'package:clothes_app/users/items/item_detail_screen.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;

class SearchItems extends StatefulWidget {
  const SearchItems({super.key, this.typeKeywords});
  final String? typeKeywords;
  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  TextEditingController searchController = TextEditingController();

  Future<List<Clothes>> readSearchRecordsFound() async {
    List<Clothes> clothesSearchList = [];

    if (searchController.text != "") {
      try {
        var res = await http.post(Uri.parse(API.searchItems), body: {
          "typedKeywords": searchController.text,
        });
        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);
          if (responseBodyOfSearchItems["success"] == true) {
            for (var eachItemData
                in responseBodyOfSearchItems["itemsFoundData"]) {
              clothesSearchList.add(Clothes.fromJson(eachItemData));
            }
          }
        } else {
          Fluttertoast.showToast(msg: "Status code is not 200");
        }
      } catch (e) {
        Fluttertoast.showToast(msg: "Errorr");
      }
    }
    return clothesSearchList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ben burada search değeri ile typekeyword değerini eşitleyecem
    searchController.text = widget.typeKeywords!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.white24,
          title: showSearchBarWidget(),
          titleSpacing: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.purpleAccent,
              ))),
      body: searchItemDesignWidget(context),
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
            onPressed: () {
              //girilen metnin anlık olarak güncellenebilmesi için setstate ekliyorum
              setState(() {});
            },
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
              onPressed: () {
                searchController.clear();
                //yine anlık olarak sonuç alabilmek için setstae ekliyorum
                setState(() {});
              },
              icon: const Icon(
                Icons.close,
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

  Widget searchItemDesignWidget(context) {
    return FutureBuilder(
      future: readSearchRecordsFound(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text("No new searc item found"),
          );
        }
        if (snapshot.data!.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Clothes eachClothItemData = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  Get.to(ItemDetailsScreen(itemInfo: eachClothItemData));
                },
                child: Container(
                  width: 200,
                  margin: EdgeInsets.fromLTRB(index == 0 ? 16 : 8, 10,
                      index == snapshot.data!.length - 1 ? 16 : 8, 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black,
                      boxShadow: const [
                        BoxShadow(
                            offset: Offset(0, 3),
                            blurRadius: 6,
                            color: Colors.white)
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  eachClothItemData.name!,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis),
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12),
                                  child: Text(
                                    "\$ ${eachClothItemData.price}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.purpleAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            //tags
                            Text(
                              "Tags:\n${eachClothItemData.tags.toString().replaceAll("[", "").replaceAll("]", "")}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: FadeInImage(
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                          placeholder: const AssetImage(
                              "assets/images/place_holder.png"),
                          image: NetworkImage(
                            eachClothItemData.image!,
                          ),
                          imageErrorBuilder: (context, error, stackTraceError) {
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
            child: Text("Empty, No data."),
          );
        }
      },
    );
  }
}
