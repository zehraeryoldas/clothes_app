import 'package:clothes_app/admin/admin_upload_items.dart';
import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/authentication/signupp_screen.dart';
import 'package:clothes_app/users/fragments/dashboard_of_freagments.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:clothes_app/users/userPreferenes/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  var formKey = GlobalKey<FormState>();
  var eMailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObscure = true.obs;

  loginAdminNow() async {
    try {
      var res = await http.post(Uri.parse(API.loginAdmin), body: {
        'admin_email': eMailController.text.trim(),
        'admin_password': passwordController.text.trim(),
      });
      if (res.statusCode == 200) {
        print("selammmmm");
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          Fluttertoast.showToast(
              msg: "Dear Admin, you are logged-in Successfully.");

          Future.delayed(const Duration(milliseconds: 2000), () {
            Get.to(const AdminUploadItemsScreen());
          });
        } else {
          Fluttertoast.showToast(
              msg:
                  "Incorrect credentials.\n Please write correct password or email and try again ");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
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
                    child: Image.asset("assets/images/admin.jpg"),
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
                                            loginAdminNow();
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

                            //I am not an admin
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("I am not an admin?"),
                                TextButton(
                                    onPressed: () {
                                      Get.to(const LoginScreen());
                                    },
                                    child: const Text(
                                      "SignUp Here",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black),
                                    ))
                              ],
                            ),
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
