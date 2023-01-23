import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:study/restaurant/component/restaurant_card.dart';
import 'package:study/restaurant/model/restaurant_model.dart';
import 'package:study/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List> paginateRestaurant() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final response = await dio.get(
      "http://$ip/restaurant",
      options: Options(
        headers: {"authorization": "Bearer $accessToken"},
      ),
    );

    return response.data["data"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }

              final item = snapshot.data!
                  .map((e) => RestaurantModel.fromJson(e))
                  .toList();

              return ListView.separated(
                itemBuilder: (_, index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailScreen(),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(model: item[index]));
                },
                separatorBuilder: (_, index) {
                  return SizedBox(
                    height: 16.0,
                  );
                },
                itemCount: snapshot.data!.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
