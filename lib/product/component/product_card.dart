import 'package:flutter/material.dart';
import 'package:study/common/const/colors.dart';
import 'package:study/common/const/data.dart';
import 'package:study/restaurant/model/restaurant_detail_model.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String name;
  final String detail;
  final int price;

  const ProductCard( {
    required this.image,
    required this.name,
    required this.detail,
    required this.price,
    Key? key,
  }) : super(key: key);

  factory ProductCard.fromModel(RestaurantProductModel model) {
    return ProductCard(
      image: Image.network(model.imgUrl, width: 110, height: 110, fit: BoxFit.cover,),
      name: model.name,
      detail: model.detail,
      price: model.price,
    );
  }

  // Image.asset(
  // "asset/img/food/ddeok_bok_gi.jpg",
  // width: 110,
  // height: 110,
  // fit: BoxFit.cover,
  // ),

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: image,
          ),
          const SizedBox(
            width: 16.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: BODY_TEXT_COLOR,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "\$$price",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
