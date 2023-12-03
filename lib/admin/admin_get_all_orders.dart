import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/users/order/order_details.dart';
import 'package:clothes_app/users/userPreferenes/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AdminGetAllOrdersScreen extends StatelessWidget {
  AdminGetAllOrdersScreen({super.key});
  final currentOnlineUser = Get.put(CurrentUser());
  Future<List<Order>> getAllOrdersList() async {
    //en son favorileri getirmeyi sağlayacaktık
    List<Order> orderList = [];

    try {
      var res = await http.post(Uri.parse(API.adminGetAllOrders), body: {
        "allOrdersData": currentOnlineUser.user.user_id.toString(),
      });
      if (res.statusCode == 200) {
        var resBodyOfGetCurrentUserOrderListItems = jsonDecode(res.body);
        if (resBodyOfGetCurrentUserOrderListItems["success"] == true) {
          //eğer başarılı dönerse alamamız gerekn kayoıtlar var
          for (var eachOrderData
              in (resBodyOfGetCurrentUserOrderListItems["allOrdersData"]
                  as List)) {
            orderList.add(Order.fromJson(eachOrderData));
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
    return orderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //order image       //history image

          //my order title    //history title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      "assets/images/orders_icon.png",
                      width: 140,
                    ),
                    const Text(
                      "My orders",
                      style: TextStyle(
                          color: Colors.purpleAccent,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    //send user to orders history screen
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/images/history_icon.png",
                          width: 12,
                        ),
                        const Text(
                          "History",
                          style: TextStyle(
                              color: Colors.purpleAccent,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //some info
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              "Here are your succesfully placed orders",
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
          ),
          Expanded(child: myOrderList(context))
          //displaying order list
        ],
      ),
    );
  }

  Widget myOrderList(context) {
    return FutureBuilder(
      future: getAllOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text("Connection waiting..")),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapShot.data == null) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text("No orders found yet..")),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapShot.data!.isNotEmpty) {
          List<Order> orderList = dataSnapShot.data!;

          return ListView.separated(
              itemBuilder: (context, index) {
                Order eachOrderData = dataSnapShot.data![index];

                return Card(
                  color: Colors.white24,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      onTap: () {
                        Get.to(OrderDetailsScreen(
                          clickedOrderInfo: eachOrderData,
                        ));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ID # ${eachOrderData.order_id}",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Amount: \$  ${eachOrderData.totalAmount.toString()}",
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //date
                          //time
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat(
                                  "dd MMMM, yyyy",
                                ).format(eachOrderData.dateTime!),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              //time
                              Text(
                                DateFormat(
                                  "hh:mm a",
                                ).format(eachOrderData.dateTime!),
                                style: const TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 4,
                          ),

                          const Icon(
                            Icons.navigate_next,
                            color: Colors.purpleAccent,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
                );
              },
              itemCount: dataSnapShot.data!.length);
        } else {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text("Nothing to show..")),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
      },
    );
  }
}
