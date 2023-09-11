import 'dart:convert';

import 'package:clothes_app/api_connection/api_connection.dart';
import 'package:clothes_app/users/authentication/login_screen.dart';
import 'package:clothes_app/users/model/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();

  var eMailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObscure = true.obs;
  //email kontrolleri sağlanıyor
  validateUserEmail() async {
    try {
      var res = await http.post(Uri.parse(API.validateEmail),
          body: {'user_email': eMailController.text.trim()});

      if (res.statusCode == 200) {
        //from flutter app connection with api to server success
        var resBodyOfValidateemail = jsonDecode(res.body);
        if (resBodyOfValidateemail['emailFound'] == true) {
          Fluttertoast.showToast(
              msg: "Email is already in someone else use? try another email");
        } else {
          registerAndSaveUserRecord();
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  registerAndSaveUserRecord() async {
    User userModel = User(1, nameController.text.trim(),
        eMailController.text.trim(), passwordController.text.trim());
    try {
      var res = await http.post(
        Uri.parse(API.signUp),
        //ve verilerimizi iletiyoruz body'ye toJson sayesinde
        body: userModel.toJson(),
      );
      if (res.statusCode == 200) {
        var resBodyOfSignUp = jsonDecode(res.body);
        if (resBodyOfSignUp['success'] == true) {
          Fluttertoast.showToast(
              msg: "Congratulations!, you are SignUp succesfully");
          setState(() {
            nameController.clear();
            eMailController.clear();
            passwordController.clear();
          });
        } else {
          Fluttertoast.showToast(msg: "Error occured , try again");
        }
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
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
                  //signup screen header
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 285,
                    child: Image.asset("assets/images/register.jpg"),
                  ),

                  //signup screen sign-up-form
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
                                      controller: nameController,
                                      validator: (value) => value == ""
                                          ? "please write name"
                                          : null,
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.black,
                                          ),
                                          hintText: "name",
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
                                    //button
                                    Material(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(38),
                                      child: InkWell(
                                        onTap: () {
                                          //unique email kontrolleri sağlanması için if şartı
                                          if (formKey.currentState!
                                              .validate()) {
                                            //validate the email
                                            validateUserEmail();
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
                                            "SignUp",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),

                            //already have an account button -button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an Account?"),
                                TextButton(
                                    onPressed: () {
                                      Get.to(const LoginScreen());
                                    },
                                    child: const Text(
                                      "Login Here",
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
