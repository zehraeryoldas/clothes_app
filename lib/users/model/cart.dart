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
      cart_id: json['cart_id'],
      user_id: json['user_id'],
      item_id: json['item_id'],
      quantity: json['quantity'],
      color: json['color'],
      size: json['size'],
      name: json['name'],
      rating: json['rating'],
      tags: json['tags'],
      price: json['price'],
      sizes: json['sizes'],
      colors: json['colors'],
      description: json['description'],
      image: json['image']);
}
