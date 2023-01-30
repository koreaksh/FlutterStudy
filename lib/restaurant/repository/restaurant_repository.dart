import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:retrofit/http.dart';
import 'package:study/common/dio/dio.dart';
import 'package:study/common/model/cursor_pagination_model.dart';

import '../../common/const/data.dart';
import '../model/restaurant_detail_model.dart';
import '../model/restaurant_model.dart';

part "restaurant_repository.g.dart";

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final repository = RestaurantRepository(dio, baseUrl: "http://$ip/restaurant");
  return repository;
});

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl})
  = _RestaurantRepository;


  @GET("/")
  @Headers({
    "accessToken" : "true"
  })
  Future<CursorPaginationModel<RestaurantModel>> paginate();


  @GET("/{id}")
  @Headers({
    "accessToken" : "true"
  })
  Future<RestaurantDetailModel> getRestaurantDetail({
  @Path() required String id,
});
}