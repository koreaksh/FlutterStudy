import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:study/common/dio/dio.dart';
import 'package:study/restaurant/component/restaurant_card.dart';
import 'package:study/restaurant/model/restaurant_model.dart';
import 'package:study/restaurant/repository/restaurant_repository.dart';
import 'package:study/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  Future<List<RestaurantModel>> paginateRestaurant() async {
    final dio = Dio();

    dio.interceptors.add(CustomInterceptor(storeage: storage));

    final response = await RestaurantRepository(dio, baseUrl:"http://$ip/restaurant").paginate();

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: FutureBuilder<List<RestaurantModel>>(
            future: paginateRestaurant(),
            builder: (context, AsyncSnapshot<List<RestaurantModel>> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.separated(
                itemBuilder: (_, index) {
                  final item = snapshot.data![index];
                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RestaurantDetailScreen(id: item.id,),
                          ),
                        );
                      },
                      child: RestaurantCard.fromModel(model: item));
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
