// ignore_for_file: lines_longer_than_80_chars

import 'package:dio/dio.dart' show Dio, DioError, DioErrorType, LogInterceptor;
import 'package:papa_burger/src/models/exceptions.dart';
import 'package:papa_burger/src/models/restaurant/restaurant.dart';
import 'package:papa_burger/src/restaurant.dart'
    show
        LocalStorage,
        MainBloc,
        RestaurantsPage,
        Tag,
        UrlBuilder,
        defaultTimeout,
        logger;
import 'package:papa_burger_server/api.dart' as server;

class RestaurantApi {
  RestaurantApi({Dio? dio, UrlBuilder? urlBuilder})
      : _dio = dio ?? Dio(),
        _urlBuilder = urlBuilder ?? UrlBuilder() {
    _dio.interceptors.add(
      LogInterceptor(
        responseBody: true,
      ),
    );
    _dio.options.connectTimeout = defaultTimeout;
    _dio.options.receiveTimeout = defaultTimeout;
    _dio.options.sendTimeout = defaultTimeout;
  }

  final Dio _dio;
  final UrlBuilder _urlBuilder;

  static final LocalStorage _localStorage = LocalStorage.instance;
  static const radius = 10000;

  late final lat = _localStorage.latitude;
  late final lng = _localStorage.longitude;

  Future<RestaurantsPage> getRestaurantsPageFromBackend({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final apiClient = server.ApiClient();

      final clientRestaurants = await apiClient.getAllRestaurants(
        latitude: latitude,
        longitude: longitude,
      );
      logger.w('Client Restaurants $clientRestaurants');
      final restaurants =
          clientRestaurants.map(Restaurant.fromBackend).toList();

      logger.w('All Restaurants $restaurants');
      return RestaurantsPage(restaurants: restaurants);
    } catch (e) {
      throw apiExceptionsFormatter(e);
    }
  }

  Future<RestaurantsPage> getDBRestaurantsPageFromBackend({
    required String latitude,
    required String longitude,
    String? limit,
    String? offset,
  }) async {
    try {
      final apiClient = server.ApiClient();

      final clientRestaurants = await apiClient.getAllDBRestaurants(
        latitude: latitude,
        longitude: longitude,
      );
      final restaurants = clientRestaurants.map(Restaurant.fromDb).toList();

      return RestaurantsPage(restaurants: restaurants);
    } catch (e) {
      throw apiExceptionsFormatter(e);
    }
  }

  Future<List<Restaurant>> getPopularRestaurantsFromBackend({
    required String latitude,
    required String longitude,
  }) async {
    final apiClient = server.ApiClient();

    final clientRestaurants = await apiClient.getPopularRestaurants(
      latitude: latitude,
      longitude: longitude,
    );
    final restaurants = clientRestaurants.map(Restaurant.fromDb).toList();

    return restaurants;
  }

  Future<RestaurantsPage> getRestaurantsPage(
    String? pageToken, {
    required bool mainPage,
    double? lat$,
    double? lng$,
  }) async {
    final url = _urlBuilder.buildNearbyPlacesUrl(
      lat: lat$ ?? lat,
      lng: lng$ ?? lng,
      radius: 10000,
      nextPageToken: pageToken,
      forMainPage: mainPage,
    );

    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
      final data = response.data;

      if (data == null) {
        throw Exception('Response is empty.');
      }

      final status = data['status'];

      if (status == 'ZERO_RESULTS') {
        logger.w(
          'Indicating that the search was successful but returned no results.',
        );
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Zero Results',
          status: status as String,
        );
      }
      if (status == 'INVALID_REQUEST') {
        logger.w(
          'Indicating the API request was malformed, generally due to the missing input parameter. $status',
        );
        throw Exception(
          'Indicating the API request was malformed, generally due to the missing input parameter. $status',
        );
      }
      if (status == 'OVER_QUERY_LIMIT') {
        logger.w(
          'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. $status',
        );
        throw Exception(
          'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. $status',
        );
      }
      if (status == 'REQUEST_DENIED') {
        logger.w('The request is missing an API key. $status');
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Request denied',
          status: status as String?,
        );
      }
      if (status == 'UNKNOWN_ERROR') {
        logger.e('Unknown error. $status');
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Unknown Error',
          status: status as String?,
        );
      }

      final restaurants = getNearbyRestaurantsByLocation(data);
      final pageToken = getNextPageToken(data);

      return RestaurantsPage(
        nextPageToken: pageToken,
        restaurants: restaurants,
      );
    } on DioError catch (error) {
      logger.e(error.error, error.stackTrace);
      if (error.type == DioErrorType.connectionTimeout) {
        return RestaurantsPage(
          restaurants: [],
          errorMessage: 'Connection Timeout',
          status: 'Connection Timeout',
        );
      }
      return RestaurantsPage(
        restaurants: [],
        errorMessage: 'Unknown error',
        status: 'Unknown error',
      );
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  String? getNextPageToken(Map<String, dynamic> data) {
    try {
      final pageToken = data['next_page_token'];

      return pageToken as String?;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  List<Restaurant> getNearbyRestaurantsByLocation(
    Map<String, dynamic> data,
  ) {
    try {
      final results = data['results'] as List;

      final restaurants = results
          .map<Restaurant>(
            (e) => Restaurant.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      return restaurants;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Restaurant getRestaurantByPlaceId(String placeId) {
    try {
      logger.i('getting restaurant by place id $placeId');
      if (placeId.isEmpty) return const Restaurant.empty();
      final restaurants = MainBloc().restaurantsPage$.restaurants;
      final restaurantById = restaurants.firstWhere(
        (restaurant) => restaurant.placeId == placeId,
        orElse: () => const Restaurant.empty(),
      );
      return restaurantById;
    } catch (e) {
      logger.e(e.toString());
      return const Restaurant.empty();
    }
  }

  Future<List<Tag>> getRestaurantsTags({
    required String latitude,
    required String longitude,
  }) async {
    try {
      final apiClient = server.ApiClient();
      final clientTags = await apiClient.getRestaurantsTags(
        latitude: latitude,
        longitude: longitude,
      );

      final tags = clientTags
          .map(
            (tag) => Tag(
              name: tag.name,
              imageUrl: tag.imageUrl,
            ),
          )
          .toList();
      return tags;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  Future<List<Restaurant>> getRestaurantsByTag({
    required String tagName,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final apiClient = server.ApiClient();
      final clientRestaurants = await apiClient.getRestaurantsByTag(
        tagName,
        latitude: latitude,
        longitude: longitude,
      );

      final restaurants = clientRestaurants.map(Restaurant.fromDb).toList();

      return restaurants;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }
}
