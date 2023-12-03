import 'dart:convert';

import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/users/order/order_details.dart';
import 'package:clothes_app/users/userPreferenes/current_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../api_connection/api_connection.dart';

class OrderFragmentScreen extends StatelessWidget {
  final currentOnlineUser = Get.put(CurrentUser());

  OrderFragmentScreen({super.key});

  Future<List<Order>> getCurrentUserOrdersList() async {
    List<Order> ordersListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(API.readOrder), body: {
        "currentOnlineUserID": currentOnlineUser.user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          for (var eachCurrentUserOrderData
              in (responseBodyOfCurrentUserOrdersList['currentUserOrdersData']
                  as List)) {
            ordersListOfCurrentUser
                .add(Order.fromJson(eachCurrentUserOrderData));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return ordersListOfCurrentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Order image       //history image
          //myOrder title     //history title
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //order icon image
                // my orders
                Column(
                  children: [
                    Image.asset(
                      "assets/images/orders_icon.png",
                      width: 140,
                    ),
                    const Text(
                      "My Orders",
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                //history icon image
                // history
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
                          width: 45,
                        ),
                        const Text(
                          "History",
                          style: TextStyle(
                            color: Colors.purpleAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          //some info
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              "Here are your successfully placed orders.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          //displaying the user orderList
          Expanded(
            child: displayOrdersList(context),
          ),
        ],
      ),
    );
  }

  Widget displayOrdersList(context) {
    return FutureBuilder(
      future: getCurrentUserOrdersList(),
      builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Connection Waiting...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapshot.data == null) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "No orders found yet...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        }
        if (dataSnapshot.data!.isNotEmpty) {
          List<Order> orderList = dataSnapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (context, index) {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemCount: orderList.length,
            itemBuilder: (context, index) {
              Order eachOrderData = orderList[index];

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
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Amount: \$ ${eachOrderData.totalAmount}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //date
                        //time
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //date
                            Text(
                              DateFormat("dd MMMM, yyyy")
                                  .format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 4),

                            //time
                            Text(
                              DateFormat("hh:mm a")
                                  .format(eachOrderData.dateTime!),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 6),

                        const Icon(
                          Icons.navigate_next,
                          color: Colors.purpleAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Nothing to show...",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
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
