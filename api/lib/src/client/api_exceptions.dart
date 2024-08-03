/// {@template yandex_food_api_exception}
/// Exceptions from Yandex Food API client.
/// {@endtemplate}
abstract class YandexFoodApiException implements Exception {
  /// {@macro yandex_food_api_exception}
  const YandexFoodApiException(this.error);

  /// The error which was caught.
  final Object error;

  @override
  String toString() => 'Yandex Food API exception error: $error';
}

/// {@template get_user_notifications_failure}
/// Thrown during the get user notifications if a failure occurs.
/// {@endtemplate}
class GetUserNotificationsFailure extends YandexFoodApiException {
  /// {@macro get_user_notifications_failure}
  const GetUserNotificationsFailure(super.error);
}

/// {@template get_restaurant_by_id}
/// Thrown during the get of restaurant by id if a failure occurs.
/// {@endtemplate}
class GetRestaurantById extends YandexFoodApiException {
  /// {@macro get_restaurant_by_id}
  const GetRestaurantById(super.error);
}

/// {@template get_restaurant_by_location_failure}
/// Thrown during the get of restaurant by location if a failure occurs.
/// {@endtemplate}
class GetRestaurantByLocationFailure extends YandexFoodApiException {
  /// {@macro get_restaurant_by_location_failure}
  const GetRestaurantByLocationFailure(super.error);
}

/// {@template get_restaurant_by_location_failure}
/// Thrown during the add of restaurant if a failure occurs.
/// {@endtemplate}
class AddRestaurantFailure extends YandexFoodApiException {
  /// {@macro get_restaurant_by_location_failure}
  const AddRestaurantFailure(super.error);
}

/// {@template update_restaurant_failure}
/// Thrown during the update of restaurant if a failure occurs.
/// {@endtemplate}
class UpdateRestaurantFailure extends YandexFoodApiException {
  /// {@macro update_restaurant_failure}
  const UpdateRestaurantFailure(super.error);
}

/// {@template delete_restaurant_failure}
/// Thrown during the delete of restaurant if a failure occurs.
/// {@endtemplate}
class DeleteRestaurantFailure extends YandexFoodApiException {
  /// {@macro delete_restaurant_failure}
  const DeleteRestaurantFailure(super.error);
}

/// {@template get_popular_restaurants_by_location_failure}
/// Thrown during the get of popular restaurants by location if a
/// failure occurs.
/// {@endtemplate}
class GetPopularRestaurantByLocationFailure extends YandexFoodApiException {
  /// {@macro get_popular_restaurants_by_location_failure}
  const GetPopularRestaurantByLocationFailure(super.error);
}

/// {@template search_restaurants_failure}
/// Thrown during the search of restaurants if a failure occurs.
/// {@endtemplate}
class SearchRestaurantsFailure extends YandexFoodApiException {
  /// {@macro search_restaurants_failure}
  const SearchRestaurantsFailure(super.error);
}

/// {@template get_restaurants_tags_failure}
/// Thrown during the get of restaurants tags if a failure occurs.
/// {@endtemplate}
class GetRestaurantsTagsFailure extends YandexFoodApiException {
  /// {@macro get_restaurants_tags_failure}
  const GetRestaurantsTagsFailure(super.error);
}

/// {@template get_restaurants_by_tags_failure}
/// Thrown during the get of restaurants by tags if a failure occurs.
/// {@endtemplate}
class GetRestaurantsByTagsFailure extends YandexFoodApiException {
  /// {@macro get_restaurants_by_tags_failure}
  const GetRestaurantsByTagsFailure(super.error);
}

/// {@template get_menu_failure}
/// Thrown during the get of menu if a failure occurs.
/// {@endtemplate}
class GetMenuFailure extends YandexFoodApiException {
  /// {@macro get_menu_failure}
  const GetMenuFailure(super.error);
}

/// {@template get_user_profile_failure}
/// Thrown during the get of user if a failure occurs.
/// {@endtemplate}
class GetUserProfileFailure extends YandexFoodApiException {
  /// {@macro get_user_profile_failure}
  const GetUserProfileFailure(super.error);
}

/// {@template add_user_credit_card_failure}
/// Thrown during the add of user credit card if a failure occurs.
/// {@endtemplate}
class AddCreditCardFailure extends YandexFoodApiException {
  /// {@macro add_user_credit_card_failure}
  const AddCreditCardFailure(super.error);
}

/// {@template delete_credit_card_failure}
/// Thrown during the get of user if a failure occurs.
/// {@endtemplate}
class DeleteCreditCardFailure extends YandexFoodApiException {
  /// {@macro delete_credit_card_failure}
  const DeleteCreditCardFailure(super.error);
}

/// {@template get_credit_cards_failure}
/// Thrown during the get of credit cards if a failure occurs.
/// {@endtemplate}
class GetCreditCardsFailure extends YandexFoodApiException {
  /// {@macro get_credit_cards_failure}
  const GetCreditCardsFailure(super.error);
}

/// {@template get_credit_card_info_failure}
/// Thrown during the get of credit card info if a failure occurs.
/// {@endtemplate}
class GetCreditCardInfoFailure extends YandexFoodApiException {
  /// {@macro get_credit_card_info_failure}
  const GetCreditCardInfoFailure(super.error);
}

/// {@template update_credit_card_failure}
/// Thrown during the update of credit card if a failure occurs.
/// {@endtemplate}
class UpdateCreditCardFailure extends YandexFoodApiException {
  /// {@macro update_credit_card_failure}
  const UpdateCreditCardFailure(super.error);
}

/// {@template get_user_failure}
/// Thrown during the get of user if a failure occurs.
/// {@endtemplate}
class GetUserFailure extends YandexFoodApiException {
  /// {@macro get_user_failure}
  const GetUserFailure(super.error);
}
