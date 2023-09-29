import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controller/cart_list_controller.dart';
import 'package:clothes_app/users/model/cart.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/userPreferenes/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CartListScreen extends StatefulWidget {
  const CartListScreen({super.key});

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  final currentOnlineUser = Get.put(CurrentUser());
  final cartListController = Get.put(CartListController());

  getCurrentUserCartList() async {
    List<Cart> cartListOfCurrentUser = [];

    var res = await http.post(Uri.parse(API.readToCart), body: {
      "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
    });

    if (res.statusCode == 200) {
      var responseBodyOfGetCurrentUserCartItems = jsonDecode(res.body);

      if (responseBodyOfGetCurrentUserCartItems['success'] == true) {
        for (var eachCurrentUserCartItemData
            in (responseBodyOfGetCurrentUserCartItems['currentUserCartData']
                as List)) {
          cartListOfCurrentUser.add(Cart.fromJson(eachCurrentUserCartItemData));
        }
      } else {
        Fluttertoast.showToast(msg: "Error Occurred while executing query");
      }

      cartListController.setList(cartListOfCurrentUser);
    } else {
      Fluttertoast.showToast(msg: "Status Code is not 200");
    }

    calculateTotalAmount();
  }

  calculateTotalAmount() {
    cartListController.setTotal(0); //başlangıçta toplam sıfıra eşitlendi
    if (cartListController.selectedItem.isNotEmpty) {
      for (var itemInCart in cartListController.cartList) {
        // Döngü her öğe için çalışırken, öğenin seçilip seçilmediğini kontrol ediyoruz. Eğer öğe seçilmişse, bu koşul sağlanır ve öğenin toplam tutarı hesaplanır.(contains)
        if (cartListController.selectedItem.contains(itemInCart.item_id)) {
          double eachItemTotalAmount = (itemInCart.price!) *
              (double.parse(itemInCart.quantity.toString()));
          cartListController
              .setTotal(cartListController.total + eachItemTotalAmount);
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() => cartListController.cartList.isNotEmpty
          ? ListView.builder(
              itemCount: cartListController.cartList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Cart cartModel = cartListController.cartList[index];
                Clothes clothesModel = Clothes(
                    item_id: cartModel.item_id,
                    colors: cartModel.colors,
                    image: cartModel.image,
                    name: cartModel.name,
                    price: cartModel.price,
                    rating: cartModel.rating,
                    sizes: cartModel.sizes,
                    description: cartModel.description,
                    tags: cartModel.tags);

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      GetBuilder(
                        init: cartListController,
                        builder: (controller) {
                          return IconButton(
                              onPressed: () {
                                cartListController
                                    .addSelectedItem(cartModel.item_id!);
                                calculateTotalAmount();
                              },
                              icon: Icon(
                                cartListController.selectedItem
                                        .contains(cartModel.item_id)
                                    ? Icons.check_box
                                    : Icons.check_box_outline_blank,
                                color: cartListController.isSelectedAll
                                    ? Colors.white
                                    : Colors.grey,
                              ));
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                0,
                                index == 0 ? 16 : 8,
                                16,
                                index == cartListController.cartList.length - 1
                                    ? 16
                                    : 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                                boxShadow: const [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 6,
                                      color: Colors.white)
                                ]),
                            child: Row(
                              children: [
                                //name
                                //clor size+price
                                //+2-
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        clothesModel.name.toString(),
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Color: ${cartModel.color!.replaceAll('[', '').replaceAll(']', '')}"
                                            "\n"
                                            "Size: ${cartModel.size!.replaceAll('[', '').replaceAll(']', '')}",
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white60),
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12, right: 12),
                                            child: Text(
                                              "\$${clothesModel.price}",
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.purpleAccent,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.white,
                                              )),
                                          Text(
                                            cartModel.quantity.toString(),
                                            style: const TextStyle(
                                                color: Colors.purpleAccent,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                //0 dan sonra -1 -2 diye inmesin diye bu şartı koyduk
                                              },
                                              icon: const Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.white,
                                              )),
                                        ],
                                      )
                                    ],
                                  ),
                                ))

                                //image
                                ,
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
                                      cartModel.image!,
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
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text("Cart is Empty"),
            )),
      bottomNavigationBar: GetBuilder(
          init: cartListController,
          builder: (controller) {
            return Container(
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -3),
                    color: Colors.white,
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  const Text(
                    "Total Amount:",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white38,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Obx(() => Text(
                        "\$${cartListController.total.toStringAsFixed(2)}",
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  const Spacer(),
                  Material(
                    color: cartListController.selectedItem.isNotEmpty
                        ? Colors.purpleAccent
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      onTap: () {},
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Text(
                          "Order Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
