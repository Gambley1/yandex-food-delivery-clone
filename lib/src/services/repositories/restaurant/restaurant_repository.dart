import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show BaseRestaurantRepository, Restaurant, RestaurantApi, Tag;

@immutable
class RestaurantRepository implements BaseRestaurantRepository {
  const RestaurantRepository({
    required this.api,
  });

  final RestaurantApi api;

  @override
  List<Restaurant> getListRestaurants() {
    final restaurants = api.getListRestaurants();
    return restaurants;
  }

  @override
  Restaurant getRestaurantById(int id) {
    final restaurant = api.getRestaurantById(id);
    return restaurant;
  }

  @override
  List<Restaurant> getRestaurantsByTag(List<String> categName, int index) {
    final restaurants =
        api.getRestaurantsByTag(categName: categName, index: index);
    return restaurants;
  }

  @override
  List<Tag> getRestaurantsTags() {
    final tags = api.getRestaurantsTags();
    return tags;
  }
}
