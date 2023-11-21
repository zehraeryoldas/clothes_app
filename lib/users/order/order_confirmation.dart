import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final List<int?>? selectedCartID;
  final List<Map<String, dynamic>>? selectedCartListItems;
  final double? totalAmount;
  final String? deliverSystem;
  final String? paymentSystem;
  final String? phoneNumber;
  final String? shipmentAddress;
  final String? note;

  const OrderConfirmationScreen({
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

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
