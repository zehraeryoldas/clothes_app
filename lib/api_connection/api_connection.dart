class API {
  static const hostConnect = "http://192.168.1.101/api_clothes_store";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";

  //signUp user
  static const validateEmail = "$hostConnect/user/validate_email.php";
  static const signUp = "$hostConnect/user/signup.php";
  static const login = '$hostConnect/user/login.php';

  //login admin
  static const loginAdmin = "$hostConnect/admin/login.php";

  //upload save new item
  static const uploadNewItem = "$hostConnect/items/upload.php";
  //Clothes
  static const getTrendingMostPopularClothes =
      "$hostConnect/clothes/trending.php";

  //allClothes
  static const getAllClothes = "$hostConnect/clothes/all.php";

  //cart to add
  static const addToCart = "$hostConnect/cart/add.php";
}
