import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:study/common/dio/dio.dart';
import 'package:study/common/layout/default_layout.dart';
import 'package:study/product/component/product_card.dart';
import 'package:study/restaurant/component/restaurant_card.dart';
import 'package:study/restaurant/model/restaurant_detail_model.dart';
import 'package:study/restaurant/repository/restaurant_repository.dart';

import '../../common/const/data.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;

  const RestaurantDetailScreen({
    required this.id,
    Key? key,
  }) : super(key: key);

  Future<RestaurantDetailModel> getRestaurantDetail() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storeage: storage),);

    final repository = RestaurantRepository(dio, baseUrl: "http://$ip/restaurant");

    return repository.getRestaurantDetail(id: id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "불타는 떡볶이",
      child: FutureBuilder<RestaurantDetailModel>(
        future: getRestaurantDetail(),
        builder: (context, AsyncSnapshot<RestaurantDetailModel> snapshot) {
          if(!snapshot.hasData) {
            print(snapshot.error);
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CustomScrollView(
            slivers: [
              renderTop(snapshot.data!),
              renderLabel(),
              renderProducts(snapshot.data!),
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
