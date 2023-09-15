import 'package:clothes_app/admin/admin_login.dart';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/signupp_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_freagments.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferenes/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formKey = GlobalKey<FormState>();
  var eMailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObscure = true.obs;

  loginUserNow() async {
    try {
      var res = await http.post(Uri.parse(API.login), body: {
        'user_email': eMailController.text.trim(),
        'user_password': passwordController.text.trim(),
      });
      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(msg: "you are logged-in succesfully");
          //aynı zamanda kulllanıcı bilgilerini iletmeliyiz ki daha sonra giriş yapıldığında
          //hafızaya bilgiler kaydedilsin.
          User userInfo = User.fromJson(resBodyOfLogin[
              'userData']); //json'dan geçirdiğimiz verileri, kullanıcıyı elde etmemize yardumcı olacaktır
          //amacımız giriş yapmış kullanıcının tüm bilgileirni hafızada tutmak
          //yerele paylaşılan referansları kullanarak uygulamaya hizmet edeceğiz.

          //: save usrInfo to local storage using shared preferences
          await RememberUserPreferences.saveRememberUser(
              userInfo); //bilgilerimizi sharedpreferencese verdik

          Future.delayed(const Duration(milliseconds: 2000), () {
            Get.to(DashBoardOfFragments());
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "incorrect credentials. Please write correct password or email and try again ");
        }
      }
    } catch (errorMsg) {
      print("Error :: $errorMsg");
    }

    //yukarıdaki kod yürütüldükten sonra başarılı mı diye kontrol edelim.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child: Image.asset("assets/images/login.jpg"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 8,
                                color: Colors.black26,
                                offset: Offset(0, -3))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                        child: Column(
                          children: [
                            //email-password-login btn
                            Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: eMailController,
                                      validator: (value) => value == ""
                                          ? "please write email"
                                          : null,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.black,
                                          ),
                                          hintText: "email",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                                color: Colors.white60),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                                color: Colors.white60),
                                          ),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                                color: Colors.white60),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: const BorderSide(
                                                color: Colors.white60),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14, vertical: 6),
                                          fillColor: Colors.white,
                                          filled: true),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Obx(
                                      () => TextFormField(
                                        obscureText: isObscure.value,
                                        controller: passwordController,
                                        validator: (value) => value == ""
                                            ? "please write password"
                                            : null,
                                        decoration: InputDecoration(
                                            prefixIcon: const Icon(
                                              Icons.vpn_key_sharp,
                                              color: Colors.black,
                                            ),
                                            suffixIcon:
                                                Obx(() => GestureDetector(
                                                      onTap: () {
                                                        isObscure.value =
                                                            !isObscure.value;
                                                      },
                                                      child: Icon(
                                                        isObscure.value
                                                            ? Icons
                                                                .visibility_off
                                                            : Icons.visibility,
                                                        color: Colors.black,
                                                      ),
                                                    )),
                                            hintText: "password..",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                  color: Colors.white60),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                  color: Colors.white60),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                  color: Colors.white60),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              borderSide: const BorderSide(
                                                  color: Colors.white60),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 6),
                                            fillColor: Colors.white,
                                            filled: true),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(38),
                                      child: InkWell(
                                        onTap: () {
                                          //öncelikle giriş formumuzu doğrulamalıyız ardından loginUserNOw methodu çağrılır
                                          //Kullanıcının giriş yapabilmesi için gerekli olan bilgileri (örneğin, e-posta ve şifre) eksiksiz ve doğru bir şekilde girmesi gerekmektedir.
                                          //Bu nedenle, kullanıcının bu bilgileri girdiği anda formun doğrulamasını yapmak, giriş işleminin başlamasını gerektiren bir şarttır.
                                          if (formKey.currentState!
                                              .validate()) {
                                            loginUserNow();
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        //padding sayesinde conteyner biraz büyüdü
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 20,
                                          ),
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),

                            //don't have an account button -button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an Account?"),
                                TextButton(
                                    onPressed: () {
                                      Get.to(const SignUpScreen());
                                    },
                                    child: const Text(
                                      "SignUp Here",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ))
                              ],
                            ),
                            const Text(
                              "Or",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                            //are you an admin-button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("are you an Admin"),
                                TextButton(
                                    onPressed: () {
                                      Get.to(const AdminLoginScreen());
                                    },
                                    child: const Text(
                                      "Click Here",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
