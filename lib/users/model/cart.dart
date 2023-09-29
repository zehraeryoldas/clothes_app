class Cart {
  int? cart_id;
  int? user_id;
  int? item_id;
  int? quantity;
  String? color;
  String? size;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;

  Cart(
      {this.cart_id,
      this.user_id,
      this.item_id,
      this.quantity,
      this.color,
      this.size,
      this.name,
      this.rating,
      this.tags,
      this.price,
      this.sizes,
      this.colors,
      this.description,
      this.image});
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      cart_id: int.parse(json['cart_id']),
      user_id: int.parse(json['user_id']),
      item_id: int.parse(json['item_id']),
      quantity: int.parse(json['quantity']),
      color: json['color'],
      size: json['size'],
      name: json['name'],
      rating: double.parse(json['rating']),
      tags: json['tags'] is String
          ? [json['tags']]
          : (json['tags'] as List<dynamic>?)
              ?.map((size) => size.toString())
              .toList(),
      price: double.parse(json['price']),
      sizes: json['sizes'] is String
          ? [json['sizes']]
          : (json['sizes'] as List<dynamic>?)
              ?.map((size) => size.toString())
              .toList(),
      colors: json['colors'] is String
          ? [json['colors']]
          : (json['colors'] as List<dynamic>?)
              ?.map((size) => size.toString())
              .toList(),
      description: json['description'],
      image: json['image']);
}
