import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/users/userPreferenes/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OrderFragmentScreen extends StatelessWidget {
  OrderFragmentScreen({super.key});
  final currentOnlineUser = Get.put(CurrentUser());
  Future<List<Order>> getCurrentOrderList() async {
    //en son favorileri getirmeyi sağlayacaktık
    List<Order> orderListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readOrder), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
      });
      if (res.statusCode == 200) {
        var resBodyOfGetCurrentUserOrderListItems = jsonDecode(res.body);
        if (resBodyOfGetCurrentUserOrderListItems["success"] == true) {
          //eğer başarılı dönerse alamamız gerekn kayoıtlar var
          for (var eachCurrentUserOrderItemData
              in (resBodyOfGetCurrentUserOrderListItems["currentUserOrdersData"]
                  as List)) {
            orderListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderItemData));
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
    return orderListOfCurrentUser;
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
              "My Order List: ",
              style: TextStyle(
                  color: Colors.purpleAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(
            height: 24,
          ),
          Expanded(child: myOrderList(context))
          //displaying order list
        ],
      ),
    );
  }

  myOrderList(context) {
    return FutureBuilder(
      future: getCurrentOrderList(),
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
          return const Center(
            child: Text(
              "No order item found",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          );
        }
        if (dataSnapShot.data!.isNotEmpty) {
          List<Order> orderList = dataSnapShot.data!;

          return ListView.separated(
              itemBuilder: (context, index) {
                Order eachOrderData = orderList[index];

                return Card(
                  color: Colors.white24,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      onTap: () {},
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
              itemCount: orderList.length);
        } else {
          return const Center(
            child: Text("Empty, No Data."),
          );
        }
      },
    );
  }
}
