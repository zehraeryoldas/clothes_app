import 'package:clothes_app/users/controller/order_now_controller.dart';
import 'package:clothes_app/users/order/order_confirmation.dart';
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

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController shipmentAddressController = TextEditingController();
  TextEditingController noteToSellerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Order Now"),
        titleSpacing: 0,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          //display selected items from cart list

          displaySelectedItemsFromUserCart(),

          const SizedBox(
            height: 30,
          ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment System: ",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Company Account Number / ID: \nY87Y-HJF9-CVBN-4321 ",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white38,
                      fontWeight: FontWeight.bold),
                ),
              ],
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
          ),
          //phone number
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Phone Number',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.white54,
              ),
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: "any Contact Number..",
                hintStyle: const TextStyle(color: Colors.white24),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white24, width: 2)),
              ),
            ),
          ),

          const SizedBox(
            height: 16,
          ),
          //shipment address
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Shipment Address: ',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.white54,
              ),
              controller: shipmentAddressController,
              decoration: InputDecoration(
                hintText: "your shipment address..",
                hintStyle: const TextStyle(color: Colors.white24),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white24, width: 2)),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          //note to seller
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Note to seller: ',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.white54,
              ),
              controller: noteToSellerController,
              decoration: InputDecoration(
                hintText: "Any note you want to write to seller..",
                hintStyle: const TextStyle(color: Colors.white24),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Colors.white24, width: 2)),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          //pay amount now btn
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: () {
                  //sevkiyat adresi ve kullanıcı telefonu çok önemlidir o yüzden bir şart gireceğiz

                  if (phoneNumberController.text == "" &&
                      shipmentAddressController.text == "") {
                    Get.to(OrderConfirmationScreen(
                      selectedCartID: selectedCartID,
                      selectedCartListItems: selectedCartListItems,
                      totalAmount: totalAmount,
                      deliverSystem: orderNowController.deliverSys,
                      paymentSystem: orderNowController.paymentSys,
                      phoneNumber: phoneNumberController.text,
                      shipmentAddress: shipmentAddressController.text,
                      note: noteToSellerController.text,
                    ));
                  }
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Text(
                          "\$${totalAmount!.toStringAsFixed(2)}",
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        const Text(
                          "Pay Amount Now",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  displaySelectedItemsFromUserCart() {
    return Column(
      children: List.generate(selectedCartListItems!.length, (index) {
        Map<String, dynamic> eachSelectedItem = selectedCartListItems![index];
        return Container(
          margin: EdgeInsets.fromLTRB(16, index == 0 ? 16 : 8, 16,
              index == selectedCartListItems!.length - 1 ? 16 : 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white24,
              boxShadow: const [
                BoxShadow(
                    offset: Offset(0, 0), blurRadius: 6, color: Colors.black26),
              ]),
          child: Row(
            children: [
              //image

              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                child: FadeInImage(
                  height: 130,
                  width: 130,
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("images/place_holder.png"),
                  image: NetworkImage(
                    eachSelectedItem["image"],
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

              //name
              //size
              //totalamount
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //name
                    //size
                    //price
                    Text(
                      eachSelectedItem['name'],
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
//size + color
                    Text(
                      eachSelectedItem['size']
                              .replaceAll("[", "")
                              .replaceAll("]", "") +
                          "\n" +
                          eachSelectedItem['color']
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "\$ ${eachSelectedItem['price']}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.purpleAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${eachSelectedItem["price"]} x ${eachSelectedItem["quantity"]} = ${eachSelectedItem["totalamount"]}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                ),
              ))

              //quantity
              ,
              Text(
                "Q: ${eachSelectedItem["quantity"]}",
                style:
                    const TextStyle(fontSize: 24, color: Colors.purpleAccent),
              )
            ],
          ),
        );
      }),
    );
  }
}
