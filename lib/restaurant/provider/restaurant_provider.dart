import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study/restaurant/model/restaurant_model.dart';

import '../repository/restaurant_repository.dart';

final restaurantProvider = StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier  = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository repository;

  RestaurantStateNotifier({required this.repository}) : super ([]) {
    paginate();
  }

  paginate() async {
    final response = await repository.paginate();
    state = response.data;
  }
}