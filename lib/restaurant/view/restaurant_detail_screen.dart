import 'package:flutter/material.dart';
import 'package:study/common/layout/default_layout.dart';
import 'package:study/product/component/product_card.dart';
import 'package:study/restaurant/component/restaurant_card.dart';

class RestaurantDetailScreen extends StatelessWidget {
  const RestaurantDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "불타는 떡볶이",
      child: CustomScrollView(
        slivers: [
          renderTop(),
          renderLabel(),
          renderProducts(),
        ],
      ),

      // Column(
      //   children: [
      //     RestaurantCard(
      //       image: Image.asset("asset/img/food/ddeok_bok_gi.jpg"),
      //       name: "불타는 떡볶이",
      //       tags: ["떡볶이", "치즈", "매운맛"],
      //       ratingsCount: 100,
      //       deliveryTime: 30,
      //       deliveryPay: 2000,
      //       ratings: 4.76,
      //       isDetail: true,
      //       detail: "맛있는 떡볶이",
      //     ),
      //     Padding(
      //       padding: EdgeInsets.symmetric(horizontal: 16.0),
      //       child: ProductCard(),
      //     ),
      //   ],
      // ),
    );
  }

  SliverPadding renderProducts() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard(),
            );
          },
          childCount: 10,
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          "메뉴",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop() {
    return SliverToBoxAdapter(
      child: RestaurantCard(
        image: Image.asset("asset/img/food/ddeok_bok_gi.jpg"),
        name: "불타는 떡볶이",
        tags: ["떡볶이", "치즈", "매운맛"],
        ratingsCount: 100,
        deliveryTime: 30,
        deliveryPay: 2000,
        ratings: 4.76,
        isDetail: true,
        detail: "맛있는 떡볶이",
      ),
    );
  }
}
