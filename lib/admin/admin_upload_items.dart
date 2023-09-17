import 'dart:convert';
import 'dart:io';

import 'package:clothes_app/admin/admin_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

class AdminUploadItemsScreen extends StatefulWidget {
  const AdminUploadItemsScreen({super.key});

  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  TextEditingController imagesController = TextEditingController();

  var imageLink = "";

  final ImagePicker _picker = ImagePicker();
  String? indirmeBaglantisi;
  XFile? pickedImageXFile;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;

  Future captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    setState(() {
      if (pickedImageXFile != null) {
        _photo = File(pickedImageXFile!.path);
        print("seloo");
        //       uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() {
      if (pickedImageXFile != null) {
        _photo = File(pickedImageXFile!.path);
        print("seloo");
        //    uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  //uploadItemFormScreen methods
  uploadItemImage() async {
    // Imgur API'ye resim yüklemek için bir HTTP isteği oluşturduk

    var requestImgurApi = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));
    // Resmin adını oluşturduk
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    // İsteğin başlık alanını ayarlayın (resmin adını kullanabilirsiniz)
    requestImgurApi.fields['title'] = imageName;
    // İsteğin başlık alanına Imgur API erişim kimliğinizi ekleyin
    requestImgurApi.headers['Authorization'] = "Client-ID " "6ca0d6456311e4d";
    // Resim dosyasını alın ve çok parçalı bir dosyaya dönüştürün
    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );
    // İsteğe resim dosyasını ekleyin
    requestImgurApi.files.add(imageFile);
    // İsteği gönderin ve Imgur API'den yanıt alın
    var responseFromImgurApi = await requestImgurApi.send();
    // Yanıtı byte dizisine dönüştürün
    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    // Byte dizisini metin olarak çözümleyin
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);
    print("Result::");
    print(resultFromImgurApi);
    // Yanıtı JSON formatına çözümleyin

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    // JSON yanıtından resim bağlantısını ve silme bağlantısını alın

    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    print("image link");
    print(imageLink);
    print("delete mash:");
    print(deleteHash);
  }
  //uploadItemFormScreen methods ends here

  // Future uploadFile() async {
  //   if (_photo == null) return;
  //   final fileName = basename(_photo!.path);
  //   final destination = 'files/$fileName';

  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child('file/');
  //     print("halo");
  //     ref.putFile(_photo!);
  //     String url = await (await ref.putFile(_photo!)).ref.getDownloadURL();
  //     setState(() {
  //       indirmeBaglantisi = url;
  //       print(url);
  //       imagesController.text = url;

  //     });
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }

  showDialogBoxForImagePickingAndCapturing(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              "Item image",
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Pick image From Phone Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget defaultScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.black54,
            Colors.deepPurple,
          ])),
        ),
        automaticallyImplyLeading: false,
        title: const Text("Welcome Admin"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.black54,
          Colors.deepPurple,
        ])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_a_photo,
                color: Colors.white54,
                size: 200,
              ),
              Material(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    showDialogBoxForImagePickingAndCapturing(context);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(
                      "Add New Item",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//uploadItemFormScreen methods

  // uploadItemImage() async {
  //   var requestImgurApi = http.MultipartRequest(
  //       "POST", Uri.parse("https://api.imgur.com/3/image"));

  //   String imageName = DateTime.now().millisecondsSinceEpoch.toString();
  // }

  Widget uploadItemFormScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.black54,
            Colors.deepPurple,
          ])),
        ),
        automaticallyImplyLeading:
            false, //otomatik olarak gelen geri tuşunu pasifleştirdik yani kaldırdık
        title: const Text("Upload form"),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.to(const AdminLoginScreen());
            },
            icon: const Icon(Icons.clear)),
        actions: [
          TextButton(
              onPressed: () {
                Get.to(const AdminLoginScreen());
              },
              child: const Text(
                "Done",
                style: TextStyle(color: Colors.green),
              ))
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(
                      File(pickedImageXFile!.path),
                    ),
                    fit: BoxFit.cover)),
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
                            _myTeextFormField("please write item name",
                                "İtem name", Icons.title, nameController),
                            const SizedBox(
                              height: 10,
                            ),
                            _myTeextFormField(
                                "please write item name",
                                "İtem rating",
                                Icons.rate_review,
                                ratingController),
                            const SizedBox(
                              height: 10,
                            ),
                            _myTeextFormField("please write item tags",
                                "İtem tags", Icons.tag, tagsController),
                            const SizedBox(
                              height: 10,
                            ),
                            _myTeextFormField(
                                "please write item price",
                                "İtem price",
                                Icons.price_change_outlined,
                                priceController),
                            const SizedBox(
                              height: 10,
                            ),
                            _myTeextFormField(
                                "please write item sizes",
                                "İtem size",
                                Icons.picture_in_picture,
                                sizesController),
                            const SizedBox(
                              height: 10,
                            ),
                            _myTeextFormField(
                                "please write item colors",
                                "İtem colors",
                                Icons.color_lens,
                                colorsController),
                            const SizedBox(
                              height: 10,
                            ),
                            _myTeextFormField(
                                "please write item description",
                                "İtem colodescriptionrs",
                                Icons.description,
                                descriptionController),
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
                                  if (formKey.currentState!.validate()) {
                                    uploadItemImage();
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
                                    "Upload now",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  TextFormField _myTeextFormField(String value, String hintext, IconData icon,
      TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) => value == "" ? value : null,
      decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          hintText: hintext,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white60),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white60),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white60),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white60),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          fillColor: Colors.white,
          filled: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null
        ? defaultScreen(context)
        : uploadItemFormScreen(context);
  }
}
