import 'package:clothes_app/users/controller/item_details_controller.dart';
import 'package:clothes_app/users/model/clothes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key, required this.itemInfo});
  final Clothes itemInfo;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  //sayfayı dinlemek için get ile aldık
  final itemDetailsController = Get.put(ItemDetailsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: const AssetImage("assets/images/place_holder.png"),
            image: NetworkImage(widget.itemInfo.image!),
            imageErrorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image_outlined),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: itemInfoWidget(),
          )
        ],
      ),
    );
  }

  Widget itemInfoWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, -3),
                blurRadius: 6,
                color: Colors.purpleAccent)
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 18,
            ),
            Center(
              child: Container(
                height: 8,
                width: 140,
                decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            //name
            Text(
              widget.itemInfo.name!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            //rating+rating num
            //tags
            //price
            //item counter
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //rating rating num
                //tags
                //price
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //rating+rating num
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: widget.itemInfo.rating!,
                          minRating: 1, //min star degree
                          direction: Axis.horizontal, //yıldızların yönü
                          allowHalfRating: true, //yarımlar gösterilsin mi
                          itemCount: 5,

                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {},
                          ignoreGestures:
                              true, //yıldızların üzeirne tyıklamayacağız sadece veritabanından gelen ratingf sayısını görüntüleyeceğiz
                          unratedColor: Colors
                              .grey, //derecelendirilmemiş yıldızların rengi
                          itemSize: 20,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "(${widget.itemInfo.rating})",
                          style: const TextStyle(
                            color: Colors.purpleAccent,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //tags
                    Text(
                      widget.itemInfo.tags
                          .toString()
                          .replaceAll("[", "")
                          .replaceAll("]", ""),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    //price
                    Text(
                      "\$${widget.itemInfo.price}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                )),

                Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              itemDetailsController.setQuantityItem(
                                  itemDetailsController.quantity + 1);
                            },
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.white,
                            )),
                        Text(
                          itemDetailsController.quantity.toString(),
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.purpleAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              //0 dan sonra -1 -2 diye inmesin diye bu şartı koyduk
                              if (itemDetailsController.quantity - 1 >= 1) {
                                itemDetailsController.setQuantityItem(
                                    itemDetailsController.quantity - 1);
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "Quantity must be 1 0r greater than 1");
                              }
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.white,
                            )),
                      ],
                    ))
              ],
            ),

            const Text(
              "size",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo.sizes!.length, (index) {
                return Obx(() => GestureDetector(
                      onTap: () {
                        itemDetailsController.setSizeItem(index);
                      },
                      child: Container(
                        height: 35,
                        width: 60,
                        decoration: BoxDecoration(
                            color: itemDetailsController.size == index
                                ? Colors.purpleAccent.withOpacity(0.2)
                                : Colors.white,
                            border: Border.all(
                                width: 2,
                                color: itemDetailsController.size == index
                                    ? Colors.green
                                    : Colors.black)),
                        alignment: Alignment.center,
                        child: Text(
                          widget.itemInfo.sizes![index]
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ));
              }),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "color",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.itemInfo.colors!.length, (index) {
                return Obx(() => GestureDetector(
                      onTap: () {
                        itemDetailsController.setColorItem(index);
                      },
                      child: Container(
                        height: 35,
                        width: 100,
                        decoration: BoxDecoration(
                            color: itemDetailsController.color == index
                                ? Colors.purpleAccent.withOpacity(0.2)
                                : Colors.white,
                            border: Border.all(
                                width: 2,
                                color: itemDetailsController.color == index
                                    ? Colors.green
                                    : Colors.black)),
                        alignment: Alignment.center,
                        child: Text(
                          widget.itemInfo.colors![index]
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ));
              }),
            ),
            const SizedBox(
              height: 8,
            ),
            //description
            const Text(
              "Description",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.itemInfo.description!,
              //metni hizalandıralım
              textAlign: TextAlign.justify,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 30,
            ),
            //add to cart
            Material(
              elevation: 4,
              color: Colors.purpleAccent,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
