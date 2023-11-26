import 'dart:convert';
import 'dart:typed_data';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/model/order.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferenes/current_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<int?>? selectedCartID;
  final List<Map<String, dynamic>>? selectedCartListItems;
  final double? totalAmount;
  final String? deliverSystem;
  final String? paymentSystem;
  final String? phoneNumber;
  final String? shipmentAddress;
  final String? note;

  OrderConfirmationScreen({
    super.key,
    this.selectedCartID,
    this.selectedCartListItems,
    this.totalAmount,
    this.deliverSystem,
    this.paymentSystem,
    this.phoneNumber,
    this.shipmentAddress,
    this.note,
  });

//  Bu satır, bir RxList nesnesi oluşturuyor.
//   RxList, GetX paketinin bir parçasıdır ve değişiklikleri dinleyebilen bir liste sağlar.
//    Burada, liste elemanları tamsayı (int) türündedir. Başlangıçta boş bir liste ile başlatılır.
  final RxList<int> _imageSelectedByte = <int>[].obs;
  Uint8List get imageSelectedByte => Uint8List.fromList(_imageSelectedByte);

  final RxString _imageSelectedName = "".obs;
  String get imageSelectedName => _imageSelectedName.value;

  final CurrentUser _currentUser = Get.put(CurrentUser());

  setSelectedImage(Uint8List selectedImage) {
    _imageSelectedByte.value = selectedImage;
  }

  setSelectedImageName(String selectedImageName) {
    _imageSelectedName.value = selectedImageName;
  }

  final ImagePicker _picker = ImagePicker();
  chooseImageFromGallery() async {
    final pickedImageXFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImageXFile != null) {
      final pickedImageBytes = await pickedImageXFile.readAsBytes();
      setSelectedImage(pickedImageBytes);
      setSelectedImageName(pickedImageXFile.path);
    } else {
      Fluttertoast.showToast(msg: "No image selected");
    }
  }

  saveNewOrderInfo() async {
    //seçilenleri içeren bu seçili kart listesi öğesi bilgisini alacağız
    // ve bunu bir dizeye dönüştüreceğiz.
    String selectedItemsString = selectedCartListItems!
        .map((eachSelectedItem) => jsonEncode(eachSelectedItem))
        .toList()
        .join("||");

    Order order = Order(
        order_id: 1,
        user_id: _currentUser.user.user_id,
        selectedItems: selectedItemsString,
        deliverSystem: deliverSystem,
        paymentSystem: paymentSystem,
        note: note,
        totalamount: totalAmount,
        image: imageSelectedName,
        status: "new",
        dateTime: DateTime.now(),
        shipmentAddress: shipmentAddress,
        phoneNumber: phoneNumber);

    try {
      var res = await http.post(Uri.parse(API.hostOrder),
          body: order.toJson(base64Encode(imageSelectedByte)));
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        if (data['success'] == true) {
        } else {
          Fluttertoast.showToast(
              msg:
                  "incorrect credentials. Please write correct password or email and try again ");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error :: $errorMsg");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            //image
            Image.asset(
              "assets/images/transaction.png",
              width: 160,
            ),
            const SizedBox(
              height: 4,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Please Attach Transaction \nProof Screenshot /image",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 30,
            ),

            //select image btn
            Material(
                elevation: 8,
                color: Colors.purpleAccent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    chooseImageFromGallery();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      child: Text(
                        "Select Image",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      )),
                )),
            const SizedBox(
              height: 16,
            ),

            //display selected image by user
            Obx(() => ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                      maxHeight: MediaQuery.of(context).size.width * 0.6),
                  //görüntünün seçili olup olmadığını kontrol edebilmek için
                  child: imageSelectedByte
                          .isNotEmpty //uzunlupa göre seçilen görüntünün sıfırdan büyük olmasıdır.
                      ? Image.memory(
                          imageSelectedByte,
                          fit: BoxFit.contain,
                        )
                      : const Placeholder(
                          color: Colors.white60,
                        ),
                )),

            const SizedBox(
              height: 16,
            ),

            //onayle ve devam et butonu
            Obx(() => Material(
                  elevation: 8,
                  color: imageSelectedByte.isNotEmpty
                      ? Colors.purpleAccent
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: () {
                      if (imageSelectedByte.isNotEmpty) {
                        //save order info
                        saveNewOrderInfo();
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "Please attach the transaction proof / screenshott.");
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      child: Text(
                        "Confirmed & Proceed",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
