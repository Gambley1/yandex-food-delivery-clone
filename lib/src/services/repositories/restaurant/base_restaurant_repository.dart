import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show Restaurant, Tag;

@immutable
abstract class BaseRestaurantRepository {
  List<Restaurant> getListRestaurants();
  List<Restaurant> getRestaurantsByTag(List<String> categName, int index);
  List<Tag> getRestaurantsTags();
  Restaurant getRestaurantById(int id);
}
