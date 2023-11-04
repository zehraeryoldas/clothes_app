import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controller/cart_list_controller.dart';
import 'package:clothes_app/users/items/item_detail_screen.dart';
import 'package:clothes_app/users/model/cart.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:clothes_app/users/order/order_now_screen.dart';
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
        Fluttertoast.showToast(msg: "your Cart list Empty");
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
        if (cartListController.selectedItem.contains(itemInCart.cart_id)) {
          double eachItemTotalAmount = (itemInCart.price!) *
              (double.parse(itemInCart.quantity.toString()));
          cartListController
              .setTotal(cartListController.total + eachItemTotalAmount);
        }
      }
    }
  }

  deleteSelectedItemsFromUserCartList(int cartID) async {
    try {
      var res = await http.post(Uri.parse(API.deleteToCart),
          body: {'cart_id': cartID.toString()});
      if (res.statusCode == 200) {
        var resDeleteOfBody = jsonDecode(res.body);
        if (resDeleteOfBody['success'] == true) {
          getCurrentUserCartList();
        } else {
          //silindikten sonra toplam tutarın güncellemsi için bir daha çağırıyoruz
          calculateTotalAmount();
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  updateQuantityUserCart(int cartID, int newQuantity) async {
    try {
      var res = await http.post(Uri.parse(API.updateItemInCartList), body: {
        'cart_id': cartID.toString(),
        'quantity': newQuantity.toString()
      });
      if (res.statusCode == 200) {
        var updateResOfBody = jsonDecode(res.body);
        if (updateResOfBody['success'] == true) {
          getCurrentUserCartList();
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  List<Map<String, dynamic>> getSelectedCartListItemsInformation() {
    List<Map<String, dynamic>> selectedCartListItemsInformation = [];

    //öncelikle seçili ürün listemizi kontrol ediyoruz
    if (cartListController.selectedItem.isNotEmpty) {
      //sepet listemizde ki her bir ürün için döngüyü çalıştırıyoruz
      //seçilen her ürün için
      for (var selectedCartListItem in cartListController.cartList) {
        //seçilen ürün listesi , seçilen ürüni eğer içeriyorsa , seçilen ürün id' lerine bakılır
        if (cartListController.selectedItem
            .contains(selectedCartListItem.cart_id)) {
          Map<String, dynamic> itemInformation = {
            "item_id": selectedCartListItem.item_id,
            "name": selectedCartListItem.name,
            "image": selectedCartListItem.image,
            "color": selectedCartListItem.color,
            "size": selectedCartListItem.size,
            "quantity": selectedCartListItem.quantity,
            "price": selectedCartListItem.price,
            "totalamount":
                selectedCartListItem.price! * selectedCartListItem.quantity!,
          };
          //ve listemize kayıt ediyoruz
          selectedCartListItemsInformation.add(itemInformation);
        }
      }
    }
    //ve bu listeyi döndürüyoruz
    return selectedCartListItemsInformation;
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("My Cart"),
        actions: [
          //to select all items
          Obx(() => IconButton(
                onPressed: () {
                  cartListController.setIsSelectedAll();
                  cartListController.clearAllSelectedItems();
                  if (cartListController.isSelectedAll) {
                    for (var eachItem in cartListController.cartList) {
                      cartListController.addSelectedItem(eachItem.cart_id!);
                    }
                  }
                },
                icon: Icon(cartListController.isSelectedAll
                    ? Icons.check_box
                    : Icons.check_box_outline_blank),
                color: cartListController.isSelectedAll
                    ? Colors.white
                    : Colors.grey,
              ))
          //to delete selected item/items
          ,
          GetBuilder(
              init: CartListController(),
              builder: (controller) {
                if (cartListController.selectedItem.isNotEmpty) {
                  return IconButton(
                      onPressed: () async {
                        var responseFromDialogBox =
                            await Get.dialog(AlertDialog(
                          backgroundColor: Colors.grey,
                          title: const Text("Delete"),
                          content: const Text(
                              "Are you sure to delete selected items from your cart list?"),
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
                                  Get.back(result: "yesDelete");
                                },
                                child: const Text(
                                  "Yes",
                                  style: TextStyle(color: Colors.black),
                                ))
                          ],
                        ));
                        if (responseFromDialogBox == "yesDelete") {
                          //delete selected items now
                          for (var selectedITemUserCartID
                              in cartListController.selectedItem) {
                            //deleted selected items now
                            deleteSelectedItemsFromUserCartList(
                                selectedITemUserCartID);
                          }
                        }
                        calculateTotalAmount();
                      },
                      icon: const Icon(
                        Icons.delete_sweep,
                        size: 30,
                        color: Colors.redAccent,
                      ));
                } else {
                  return Container();
                }
              })
        ],
      ),
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
                                if (cartListController.selectedItem
                                    .contains(cartModel.cart_id)) {
                                  cartListController
                                      .deleteSelectedITem(cartModel.cart_id!);
                                } else {
                                  cartListController
                                      .addSelectedItem(cartModel.cart_id!);
                                }

                                calculateTotalAmount();
                              },
                              icon: Icon(
                                cartListController.selectedItem
                                        .contains(cartModel.cart_id)
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
                          onTap: () {
                            Get.to(ItemDetailsScreen(itemInfo: clothesModel));
                          },
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
                                              onPressed: () {
                                                updateQuantityUserCart(
                                                    cartModel.cart_id!,
                                                    cartModel.quantity! + 1);
                                                calculateTotalAmount();
                                              },
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
                                                if (cartModel.quantity! - 1 >=
                                                    1) {
                                                  updateQuantityUserCart(
                                                      cartModel.cart_id!,
                                                      cartModel.quantity! - 1);
                                                  calculateTotalAmount();
                                                }
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
                      onTap: () {
                        //seçilen ürün sayısı sıfırdan büyük ise geçiş yap
                        cartListController.selectedItem.isNotEmpty
                            ? Get.to(OrderNowScreen(
                                selectedCartListItems:
                                    getSelectedCartListItemsInformation(), //kullanıcı kartı listesinde ki seçilen bilgiler,
                                totalAmount:
                                    cartListController.total, //ve toplam tutar
                                selectedCartID: cartListController.selectedItem,
                              ))
                            : null;
                      },
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
