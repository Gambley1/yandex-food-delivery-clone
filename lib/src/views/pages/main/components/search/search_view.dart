import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/views/pages/main/components/restaurant/restaurants_list_view.dart';
import 'package:papa_burger/src/views/pages/main/components/search/search_bar.dart';
import 'package:papa_burger/src/views/pages/main/state/main_bloc.dart';
import 'package:papa_burger/src/views/pages/main/state/search_bloc.dart';
import 'package:papa_burger/src/views/pages/main/state/search_result.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final Random random = Random(11);

  late SearchBloc _searchBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchBloc = SearchBloc(api: SearchApi());
  }

  @override
  void dispose() {
    _searchBloc.dispose();
    super.dispose();
  }

  Padding _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
      child: Row(
        children: [
          CustomIcon(
            type: IconType.iconButton,
            onPressed: () => context.pop(),
            icon: FontAwesomeIcons.arrowLeft,
          ),
          Expanded(
            child: CustomSearchBar(
              onChanged: _searchBloc.search.add,
              labelText: quickSearchLabel,
              controller: _searchController,
              withNavigation: false,
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildPopularRestaurants(BuildContext context) {
    final restaurants = MainBloc().popularRestaurants;
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          final deliveryTime = restaurant.deliveryTime;
          final deliverByWalk = deliveryTime < 8;
          final deliveryTime$ = deliverByWalk ? 15 : deliveryTime;
          return ListTile(
            onTap: () => context.navigateToMenu(context, restaurant),
            contentPadding: const EdgeInsets.symmetric(
              vertical: kDefaultHorizontalPadding - 4,
              horizontal: kDefaultHorizontalPadding,
            ),
            leading: CachedImage(
              width: 60,
              imageType: CacheImageType.smallImage,
              imageUrl: restaurant.imageUrl,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'Menu${restaurant.name}',
                  child: KText(
                    text: restaurant.name,
                    size: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                KText(
                  text: '${deliveryTime$} - ${deliveryTime$ + 10} min',
                  color: Colors.grey,
                ),
              ],
            ),
          );
        },
        itemCount: restaurants.length,
      ).disalowIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      releaseFocus: true,
      body: Column(
        children: [
          _appBar(context),
          StreamBuilder<SearchResult?>(
            stream: _searchBloc.results,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final result = snapshot.data;
                if (result is SearchResultsError) {
                  return const Column(
                    children: [
                      KText(
                        text: 'Unable to search for restaurants😕',
                        fontWeight: FontWeight.bold,
                        size: 24,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                } else if (result is SearchResultsLoading) {
                  return const CustomCircularIndicator(color: Colors.black);
                } else if (result is SearchResultsNoResults) {
                  return const Column(
                    children: [
                      KText(
                        text: 'Nothing found!',
                        size: 26,
                      ),
                      KText(
                        text: 'Please try again.',
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  );
                } else if (result is SearchResultsWithResults) {
                  return Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final restaurant = result.restaurants[index];
                        final name = restaurant.name;
                        final rating = restaurant.rating;
                        final tags = restaurant.tags;
                        final numOfRatings = restaurant.userRatingsTotal ?? 0;
                        final quality = restaurant.quality(rating as double);
                        final imageUrl = restaurant.imageUrl;
                        final deliveryTime = restaurant.deliveryTime;
                        final priceLevel = restaurant.priceLevel ?? 0;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultHorizontalPadding,
                            vertical: kDefaultHorizontalPadding,
                          ),
                          child: RestaurantCard(
                            restaurant: restaurant,
                            imageUrl: imageUrl,
                            name: name,
                            priceLevel: priceLevel,
                            tags: tags,
                            rating: rating,
                            quality: quality,
                            numOfRatings: numOfRatings,
                            deliveryTime: deliveryTime,
                          ),
                        );
                      },
                      itemCount: result.restaurants.length,
                    ).disalowIndicator(),
                  );
                } else {
                  return const KText(text: 'Unhandled state');
                }
              } else {
                return _buildPopularRestaurants(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
