import 'package:get/get.dart';

class OrderNowController extends GetxController {
  //default değerler atandı
  final RxString _deliverySystem = "FedEx".obs;
  final RxString _paymentSystem = "FedEx".obs;

  String get deliverSys => _deliverySystem.value;
  String get paymentSys => _paymentSystem.value;

  setDeliverSyatem(String newDeliverSystem) {
    _deliverySystem.value = newDeliverSystem;
  }

  setPaymentSystem(String newPaymentSystem) {
    _paymentSystem.value = newPaymentSystem;
  }
}
