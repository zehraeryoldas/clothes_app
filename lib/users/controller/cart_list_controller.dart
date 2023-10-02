import 'package:clothes_app/users/model/cart.dart';
import 'package:get/get.dart';

class CartListController extends GetxController {
  final RxList<Cart> _cartList = <Cart>[].obs; //user all items in cart
  final RxList<int> _selectedItem = <int>[]
      .obs; ////kullanıcının devam etmek istediği ve son siparişi vermek istediği öğeleri seçti
  final RxBool _isSelectedAll = false.obs;
  final RxDouble _total = 0.0.obs;

  List<Cart> get cartList => _cartList.value;
  List<int> get selectedItem => _selectedItem.value;
  bool get isSelectedAll => _isSelectedAll.value;
  double get total => _total.value;

  setList(List<Cart> list) {
    _cartList.value = list;
  }

//sepete ürün ekleme kodu
  addSelectedItem(int selectedCartID) {
    _selectedItem.value.add(selectedCartID);
    update();
  }

//sepetten ürün silme kodu
  deleteSelectedITem(int selectedItemCartID) {
    _selectedItem.value.remove(selectedItemCartID);
    update();
  }

//sepetteki tüm ürünleri seçme kodu
  setIsSelectedAll() {
    _isSelectedAll.value = !_isSelectedAll.value;
  }

//sepeti temizleme
  clearAllSelectedItems() {
    _selectedItem.value.clear();
    update();
  }

//toplam miktar hesaplama
  setTotal(double overallTotal) {
    _total.value = overallTotal;
  }
}
