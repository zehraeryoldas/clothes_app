class API {
  static const hostConnect = "http://192.168.1.100/api_clothes_store";
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

  //cart to read
  static const readToCart = "$hostConnect/cart/read.php";

  //cart to delete
  static const deleteToCart = "$hostConnect/cart/delete.php";

  //updateItemInCartList
  static const updateItemInCartList = "$hostConnect/cart/update.php";

//favoriteAdd
  static const favoriteAdd = "$hostConnect/favorite/add.php";

//favoriteDelete
  static const favoriteDelete = "$hostConnect/favorite/delete.php";

//favoriteValidate
  static const favoriteValidate = "$hostConnect/favorite/validate_favorite.php";

  //readToFavorite
  static const readToFavorite = "$hostConnect/favorite/read.php";
}
