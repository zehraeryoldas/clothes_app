import 'package:clothes_app/users/controller/order_now_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderNowScreen extends StatelessWidget {
  OrderNowScreen(
      {super.key,
      this.selectedCartListItems,
      this.totalAmount,
      this.selectedCartID});

  OrderNowController orderNowController = Get.put(OrderNowController());
  List<String> deliverySystemNamesList = [
    "FedEx",
    "DHL",
    "United Parcel Service"
  ];
  List<String> applePaySystemNamesList = [
    "Apple Pay",
    "Wire transfer",
    "Google Pay",
  ];
  final List<Map<String, dynamic>>? selectedCartListItems;
  final double? totalAmount;
  final List<int>? selectedCartID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
//delivery sistem
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Delivery System: ",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: deliverySystemNamesList.map((deliverySystemName) {
                return Obx(() => RadioListTile<String>(
                    tileColor: Colors.white24,
                    dense: true,
                    activeColor: Colors.purpleAccent,
                    title: Text(
                      deliverySystemName,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white38),
                    ),
                    value: deliverySystemName,
                    groupValue: orderNowController.deliverSys,
                    onChanged: (newDeliverSystemValue) {
                      orderNowController
                          .setDeliverSyatem(newDeliverSystemValue!);
                    }));
              }).toList(),
            ),
          ),

//payment sistem
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Payment System: ",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: applePaySystemNamesList.map((paymentSystemName) {
                return Obx(() => RadioListTile<String>(
                    tileColor: Colors.white24,
                    dense: true,
                    activeColor: Colors.purpleAccent,
                    title: Text(
                      paymentSystemName,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white38),
                    ),
                    value: paymentSystemName,
                    groupValue: orderNowController.paymentSys,
                    onChanged: (newPaymentSystemValue) {
                      orderNowController
                          .setPaymentSystem(newPaymentSystemValue!);
                    }));
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
