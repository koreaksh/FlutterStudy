import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study/common/dio/dio.dart';
import 'package:study/common/model/cursor_pagination_model.dart';
import 'package:study/restaurant/component/restaurant_card.dart';
import 'package:study/restaurant/model/restaurant_model.dart';
import 'package:study/restaurant/provider/restaurant_provider.dart';
import 'package:study/restaurant/repository/restaurant_repository.dart';
import 'package:study/restaurant/view/restaurant_detail_screen.dart';

import '../../common/const/data.dart';

class RestaurantScreen extends ConsumerWidget {
  const RestaurantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(restaurantProvider);

    if (data.length == 0) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
          itemBuilder: (_, index) {
            final item = data[index];
            return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailScreen(
                        id: item.id,
                      ),
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
          itemCount: data.length),
    );
  }
}
