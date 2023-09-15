class API {
  static const hostConnect = "http://192.168.1.9/api_clothes_store";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectAdmin = "$hostConnect/admin";

  //signUp user
  static const validateEmail = "$hostConnect/user/validate_email.php";
  static const signUp = "$hostConnect/user/signup.php";
  static const login = '$hostConnect/user/login.php';

  //login admin
  static const loginAdmin = "$hostConnect/admin/login.php";
}
