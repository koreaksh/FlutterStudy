import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:study/common/layout/default_layout.dart';
import 'package:study/product/component/product_card.dart';
import 'package:study/restaurant/component/restaurant_card.dart';
import 'package:study/restaurant/model/restaurant_detail_model.dart';

import '../../common/const/data.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();
    final response = await dio.get(
      "http://$ip/restaurant/$id",
      options: Options(
        headers: {
          "authorization": "Bearer ${await storage.read(key: ACCESS_TOKEN_KEY)}"
        },
      ),
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "불타는 떡볶이",
      child: FutureBuilder<Map<String,dynamic>>(
        future: getRestaurantDetail(),
        builder: (context, AsyncSnapshot<Map<String,dynamic>> snapshot) {
          if(!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final item = RestaurantDetailModel.fromJson(snapshot.data!);

          return CustomScrollView(
            slivers: [
              renderTop(item),
              renderLabel(),
              renderProducts(item),
            ],
          );
        },
      ),
    );
  }

  SliverPadding renderProducts(RestaurantDetailModel model) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ProductCard.fromModel(model.products[index]),);
          },
          childCount: model.products.length,
        ),
      ),
    );
  }

  SliverPadding renderLabel() {
    return const SliverPadding(
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

  SliverToBoxAdapter renderTop(RestaurantDetailModel model) {
    return SliverToBoxAdapter(
      child: RestaurantCard.fromModel(model: model, isDetail: true,),
    );
  }
}
