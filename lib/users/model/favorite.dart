//favorilediklerimizi alabilmemiz için model oluşturmamız gerekmektedir.

class Favorite {
  int? favorite_id;
  int? user_id;
  int? item_id;
  String? name;
  double? rating;
  List<String>? tags;
  double? price;
  List<String>? sizes;
  List<String>? colors;
  String? description;
  String? image;

  Favorite(
      {this.favorite_id,
      this.user_id,
      this.item_id,
      this.name,
      this.rating,
      this.tags,
      this.price,
      this.sizes,
      this.colors,
      this.description,
      this.image});
  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
      favorite_id: int.parse(json['favorite_id']),
      user_id: int.parse(json['user_id']),
      item_id: int.parse(json['item_id']),
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
