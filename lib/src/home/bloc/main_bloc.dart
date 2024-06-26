// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    show FicListExtension;
import 'package:papa_burger/src/home/bloc/main_page_state.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared/shared.dart';

class MainBloc {
  factory MainBloc() => _instance;

  MainBloc._() {
    // _fetchFirstPage(null, true);
    // fetchAllRestaurantsByLocation();
  }
  static final MainBloc _instance = MainBloc._();

  final _restaurantsPageSubject =
      BehaviorSubject<RestaurantsPage>.seeded(RestaurantsPage(restaurants: []));

  double get tempLat => LocalStorage().tempLatitude;
  double get tempLng => LocalStorage().tempLongitude;
  bool get hasNewLatLng => tempLat != 0 && tempLng != 0;
  void get removeTempLatLng => LocalStorage().clearTempLatLng();
  void get clearAllRestaurants {
    popularRestaurants.clear();
    filteredRestaurantsByTag.clear();
    restaurantsTags.clear();
  }

  RestaurantsPage get restaurantsPage$ => _restaurantsPageSubject.value;
  bool get hasMore => restaurantsPage$.hasMore ?? false;

  Stream<RestaurantsPage> get restaurantsPageStream =>
      _restaurantsPageSubject.stream.distinct();

  List<Restaurant> allRestaurants = [];
  List<Restaurant> popularRestaurants = [];
  List<Restaurant> filteredRestaurantsByTag = [];
  List<Tag> restaurantsTags = [];
  String? pageToken;

  Future<void> refresh() async {
    if (popularRestaurants.isNotEmpty && restaurantsTags.isNotEmpty) {
      _restaurantsPageSubject.add(
        RestaurantsPage(restaurants: []),
      );
    } else {
      _restaurantsPageSubject.add(
        RestaurantsPage(restaurants: []),
      );
      await _getPopularRestaurants;
      await _getRestaurantsTags;
    }
  }

  /// Stream to maintain all possible states of main page restaurants page
  /// from backend.
  ///
  /// Before it goes to the computing the method where we get our restaurants, we
  /// check whether _restaurantsPageSubject value(page) is empty, if it is not empty
  /// returning already existing restaurants in order to avoid unnecessary Backend
  /// API call.
  ///
  /// Gets Restaurants page from Backend and return appropriate state depending on
  /// the result from [getRestaurantsPageFromBackend()] method. Whether it's empty
  /// returning MainPageStateWithNoRestaurants. If it has error returning MainPageError
  /// and if it has restaurants returning MainPageWithRestaurants.
  Stream<MainPageState> get mainPageState {
    return _restaurantsPageSubject.distinct().switchMap(
      (page) {
        if (page.restaurants.isEmpty) {
          final lat = LocalStorage().latitude.toString();
          final lng = LocalStorage().longitude.toString();
          return Rx.fromCallable(
            () => RestaurantApi()
                .getRestaurantsPage(
                  latitude: lat,
                  longitude: lng,
                )
                .timeout(const Duration(seconds: 5)),
          ).map(
            (newPage) {
              if (newPage.restaurants.isEmpty) {
                return const MainPageWithNoRestaurants();
              }
              _filterPage(newPage);
              page.restaurants.clear();
              page.restaurants.addAll(newPage.restaurants);
              return MainPageWithRestaurants(restaurants: newPage.restaurants);
            },
          ).onErrorReturnWith(
            (error, stackTrace) {
              logE(
                'Failed to get restaurants page',
                error: error,
                stackTrace: stackTrace,
              );
              return MainPageError(error: error);
            },
          ).startWith(const MainPageLoading());
        } else {
          logI('Returning already existing Restaurants from stream.');
          return Stream<MainPageWithRestaurants>.value(
            MainPageWithRestaurants(restaurants: page.restaurants),
          );
        }
      },
    );
  }

  Future<RestaurantsPage> get _getRestaurantsPage async {
    final lat = LocalStorage().latitude.toString();
    final lng = LocalStorage().longitude.toString();
    return RestaurantApi().getRestaurantsPage(latitude: lat, longitude: lng);
  }

  Future<void> get _getPopularRestaurants async {
    final lat = LocalStorage().latitude.toString();
    final lng = LocalStorage().longitude.toString();
    final restaurants = await RestaurantApi().getPopularRestaurants(
      latitude: lat,
      longitude: lng,
    );
    popularRestaurants
      ..clear()
      ..addAll(restaurants);
  }

  Future<void> get _getRestaurantsTags async {
    final lat = LocalStorage().latitude.toString();
    final lng = LocalStorage().longitude.toString();
    final tags = await RestaurantApi().getRestaurantsTags(
      latitude: lat,
      longitude: lng,
    );
    restaurantsTags
      ..clear()
      ..addAll(tags);
  }

  // Everything that is commented in this file and everything that is connected
  // to it it means that I no longer use this methods due to unavailability to
  // use Google maps APIs due to billing problems.
  //
  // So, instead of it I use my own Backend server from where I can get my own
  // Restaurants and other data.

  // Future<void> filterRestaurantsByTag(String tagName) async {
  //   final restaurants =
  //       await RestaurantApi().getRestaurantsByTag(tagName: tagName);
  //   filteredRestaurantsByTag = restaurants;
  // }
  // Future<List<Restaurant>> filterRestaurantsByTag(String tagName) async {
  //   final lat = LocalStorage().latitude.toString();
  //   final lng = LocalStorage().longitude.toString();
  //   return RestaurantApi().getRestaurantsByTags(
  //     tagName: tagName,
  //     latitude: lat,
  //     longitude: lng,
  //   );
  // }

  // Future<RestaurantsPage> fetchFirstPage(
  //     String? pageToken, bool forMainPage) async {
  //   final firstPage =
  //       await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
  //   _doSomeFilteringOnPage(firstPage.restaurants);
  //   return firstPage;
  // }

  // void _fetchFirstPage(String? pageToken, bool forMainPage) async {
  //   logger.w('Fetching for first page by Page Token $pageToken');
  //   // final firstPage =
  //   //     await _restaurantService.getRestaurantsPage(pageToken, forMainPage);
  //   final firstPage = await _getRestaurantsPage;
  //   _doSomeFilteringOnPage(firstPage.restaurants);
  //   // restaurants = firstPage.restaurants;
  //   final hasMore = firstPage.nextPageToken == null ? false : true;
  //   _restaurantsPageSubject.add(
  //     RestaurantsPage(
  //       restaurants: firstPage.restaurants,
  //       errorMessage: firstPage.errorMessage,
  //       hasMore: hasMore,
  //       nextPageToken: firstPage.nextPageToken,
  //       status: firstPage.status,
  //     ),
  //   );
  //   // logger.w('GOT SOME RESTAURANTS ${firstPage.restaurants}');
  // }

  Future<void> fetchAllRestaurantsByLocation({
    bool updateByNewLatLng = false,
    double? lat,
    double? lng,
  }) async {
    if (updateByNewLatLng && lat != null && lng != null) {
      /// Clearing all and then fetching again for new restaurants with new
      /// lat and lng.
      allRestaurants.clear();
      await _getAllRestaurants(lat: lat, lng: lng);
    } else {
      await _getRestaurantsTags;
      // _getAllRestaurants(),
      await _getPopularRestaurants;
    }
  }

  Future<void> _getAllRestaurants({double? lat, double? lng}) async {
    // final page = await _restaurantService.getRestaurantsPage(
    //   pageToken,
    //   true,
    //   lat: lat,
    //   lng: lng,
    // );
    logI('Getting all restaurants');
    final page = await _getRestaurantsPage;
    allRestaurants.addAll(page.restaurants);
    _filterPage(page);
    _restaurantsPageSubject.add(
      RestaurantsPage(
        restaurants: page.restaurants,
      ),
    );
    // pageToken = page.nextPageToken;
    // final hasMore = page.nextPageToken == null ? false : true;
    // logger.w(
    //     'All restaurants $allRestaurants and length
    //  is ${allRestaurants.length}');
    // await Future.delayed(const Duration(milliseconds: 1800));
    // if (hasMore) {
    //   logger.w('Fetching for one more time');
    //   fetchAllRestaurantsByLocation();
    // } else {
    //   _restaurantsPageSubject.add(
    //     RestaurantsPage(
    //       restaurants: allRestaurants,
    //       hasMore: false,
    //     ),
    //   );
    // }
  }

  void _filterPage(
    RestaurantsPage page,
  ) {
    page.restaurants
      ..removeWhere(
        (restaurant) =>
            restaurant.name == 'Ne Rabotayet' ||
            (restaurant.permanentlyClosed ?? false),
      )
      ..removeDuplicates(
        by: (restaurant) => restaurant.name,
      )
      ..whereMoveToTheFront((restaurant) {
        final rating = restaurant.rating as double;
        return rating >= 4.8 || restaurant.userRatingsTotal! >= 300;
      })
      ..whereMoveToTheEnd((restaurant) {
        if (restaurant.rating != null) {
          final rating = restaurant.rating as double;
          return rating < 4.5 || restaurant.userRatingsTotal == null;
        }
        return false;
      });
  }
}
