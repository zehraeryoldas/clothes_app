import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/controller/cart_list_controller.dart';
import 'package:clothes_app/users/model/cart.dart';
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
    try {
      var res = await http.post(Uri.parse(API.readToCart), body: {
        //aktif kullanıcının kendi id'sini vermek zorundayız
        'currentUserCartData': currentOnlineUser.user.user_id.toString()
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error:: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
