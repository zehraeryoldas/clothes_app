class Order {
  int? order_id;
  int? user_id;
  String? selectedItems;
  String? deliverSystem;
  String? paymentSystem;
  String? note;
  double? totalamount;
  String? image;
  String? status;
  DateTime? dateTime;
  String? shipmentAddress;
  String? phoneNumber;

  Order({
    this.order_id,
    this.user_id,
    this.selectedItems,
    this.deliverSystem,
    this.paymentSystem,
    this.note,
    this.totalamount,
    this.image,
    this.status,
    this.dateTime,
    this.shipmentAddress,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson(String imageSelectedBase64) => {
        "order_id": order_id,
        "user_id": user_id,
        "selectedItems": selectedItems,
        "deliverSystem": deliverSystem,
        "paymentSystem": paymentSystem,
        "note": note,
        "totalamount": totalamount!.toStringAsFixed(2),
        "image": image,
        "status": status,
        "dateTime": dateTime,
        "shipmentAddress": shipmentAddress,
        "phoneNumber": phoneNumber,
        "imageFile": imageSelectedBase64,
      };
}
