import 'package:flutter/material.dart';

class OrderNowScreen extends StatelessWidget {
  const OrderNowScreen(
      {super.key,
      required this.selectedCartListItems,
      required this.totalAmount,
      required this.selectedCartID});

  final List<Map<String, dynamic>> selectedCartListItems;
  final double totalAmount;
  final List<int> selectedCartID;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
