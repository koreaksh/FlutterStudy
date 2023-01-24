import 'package:study/restaurant/model/restaurant_model.dart';

import '../../common/const/data.dart';

class RestaurantDetailModel extends RestaurantModel {
  final String detail;
  final List<RestaurantProductModel> products;

  RestaurantDetailModel({
    required super.id,
    required super.name,
    required super.thumbUrl,
    required super.tags,
    required super.priceRange,
    required super.ratings,
    required super.ratingsCount,
    required super.deliveryTime,
    required super.deliveryFee,
    required this.detail,
    required this.products,
  });

  factory RestaurantDetailModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailModel(
      id: json["id"],
      name: json["name"],
      thumbUrl: "http://$ip${json["thumbUrl"]}",
      tags: List<String>.from(json["tags"]),
      priceRange: RestaurantPriceRange.values
          .firstWhere((e) => e.name == json["priceRange"]),
      ratings: json["ratings"],
      ratingsCount: json["ratingsCount"],
      deliveryTime: json["deliveryTime"],
      deliveryFee: json["deliveryTime"],
      detail: json["detail"],
      products: json["products"].map<RestaurantProductModel>((e) => RestaurantProductModel.fromJson(e)).toList(),
    );
  }
}

class RestaurantProductModel {
  final String id;
  final String name;
  final String imageUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) {
    return RestaurantProductModel(
      id: json["id"],
      name: json["name"],
      imageUrl: "http://$ip${json["imgUrl"]}",
      detail: json["detail"],
      price: json["price"],
    );
  }
}
