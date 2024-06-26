// ignore_for_file: avoid_dynamic_calls

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger_server/api.dart' as server;
import 'package:shared/shared.dart';

@immutable
class Restaurant {
  const Restaurant({
    required this.businessStatus,
    required this.name,
    required this.placeId,
    required this.tags,
    required this.imageUrl,
    required this.openingHours,
    required this.deliveryTime,
    this.isFavourite = false,
    this.geometry,
    this.icon,
    this.iconBackgroundColor,
    this.iconMaskBaseUri,
    this.photos,
    this.plusCode,
    this.priceLevel,
    this.rating,
    this.reference,
    this.scope,
    this.userRatingsTotal,
    this.vicinity,
    this.permanentlyClosed,
  });

  const Restaurant.empty()
      : businessStatus = '',
        geometry = const Geometry.empty(),
        icon = '',
        iconBackgroundColor = '',
        iconMaskBaseUri = '',
        name = '',
        photos = const [],
        placeId = '',
        rating = 0,
        openingHours = const OpeningHours.closed(),
        tags = const [],
        priceLevel = 0,
        plusCode = const PlusCode.empty(),
        reference = '',
        vicinity = '',
        scope = '',
        userRatingsTotal = 0,
        permanentlyClosed = true,
        imageUrl = '',
        isFavourite = false,
        deliveryTime = 0;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    String imageUrl(Map<String, dynamic> json) {
      final isNotEmpty = json['photos'] != null ||
          List<dynamic>.from(json['photos'] as List).isNotEmpty;
      if (isNotEmpty) {
        final photoReference = json['photos'][0]['photo_reference'] as String;
        final photoWidth = json['photos'][0]['width'] as String;
        return 'https://maps.googleapis.com/maps/api/place/photo?key=AIzaSyCpduAH-GFwI1zzv3RCwvvveyDP7JsSink&photoreference=$photoReference&maxwidth=$photoWidth';
      } else {
        return 'https://static.heyyou.io/images/vendor/cover/default_vendor_cover-640x300.jpg';
      }
    }

    return Restaurant(
      deliveryTime: json['delivery_time'] as int,
      businessStatus: json['business_status'] as String,
      geometry: Geometry.fromJson(json['geometry'] as Map<String, dynamic>?),
      icon: json['icon'] as String? ?? '',
      iconBackgroundColor: json['icon_background_color'] as String? ?? '',
      iconMaskBaseUri: json['icon_mask_base_uri'] as String? ?? '',
      name: json['name'] as String,
      openingHours:
          OpeningHours.fromJson(json['opening_hours'] as Map<String, dynamic>?),
      photos: json['photos'] != null
          ? List<dynamic>.from(
              json['photos'] as List,
            ).map((e) => Photos.fromJson(e as Map<String, dynamic>)).toList()
          : [],
      placeId: json['place_id'] as String,
      plusCode: PlusCode.fromJson(json['plus_code'] as Map<String, dynamic>?),
      priceLevel: json['price_level'] as int? ?? 0,
      rating: json['rating'] as double? ?? 0,
      reference: json['reference'] as String? ?? '',
      scope: json['scope'] as String? ?? '',
      tags: List<Tag>.from(
        json['tags'] as List,
      ),
      permanentlyClosed: json['permanently_closed'] as bool?,
      userRatingsTotal: json['user_ratings_total'] as int?,
      vicinity: json['vicinity'] as String,
      imageUrl: json['image_url'] as String? ?? imageUrl(json),
    );
  }

  factory Restaurant.fromDb(server.Restaurant rest) {
    return Restaurant(
      deliveryTime: rest.deliveryTime,
      businessStatus: rest.businessStatus,
      name: rest.name,
      placeId: rest.placeId,
      tags: List<Tag>.from(
        rest.tags.map(
          (e) => Tag(name: e as String, imageUrl: ''),
        ),
      ),
      imageUrl: rest.imageUrl,
      rating: rest.rating,
      userRatingsTotal: rest.userRatingsTotal,
      openingHours: OpeningHours(openNow: rest.openNow),
    );
  }

  final String businessStatus;
  final Geometry? geometry;
  final String? icon;
  final String? iconBackgroundColor;
  final String? iconMaskBaseUri;
  final String name;
  final OpeningHours openingHours;
  final List<Photos>? photos;
  final String placeId;
  final PlusCode? plusCode;
  final int? priceLevel;
  final dynamic rating;
  final String? reference;
  final String? scope;
  final List<Tag> tags;
  final int? userRatingsTotal;
  final String? vicinity;
  final bool? permanentlyClosed;
  final String imageUrl;
  final bool isFavourite;
  final int deliveryTime;

  String quality(double rating) {
    var ok = false;
    var good = false;
    var perfect = false;
    if (rating is int) {
      ok = rating >= 2;
      good = rating >= 3;
      perfect = rating >= 4;
    } else {
      ok = rating >= 3;
      good = rating <= 4 && rating >= 3.5;
      perfect = rating >= 4.2;
    }

    if (ok) return 'OK';
    if (good) return 'Good';
    if (perfect) return 'Perfect';
    return '';
  }

  String formattedTag(List<String> tags$) => tags$.length == 1
      ? tags$.first.capitalized()
      : '${tags$.first.capitalized()}, ${tags$.last.capitalized()}';

  /// CopyWith Function is used to copy the object itself to modify only
  /// specific field that needed without touching others.
  Restaurant copyWith({
    String? businessStatus,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photos>? photos,
    PlusCode? plusCode,
    int? priceLevel,
    dynamic rating,
    String? reference,
    String? scope,
    int? userRatingsTotal,
    bool? permanentlyClosed,
    String? vicinity,
    String? placeId,
    List<Tag>? tags,
    List<Menu>? menu,
    String? imageUrl,
    bool? isFavourite,
    int? deliveryTime,
  }) {
    return Restaurant(
      deliveryTime: deliveryTime ?? this.deliveryTime,
      businessStatus: businessStatus ?? this.businessStatus,
      geometry: geometry ?? this.geometry,
      icon: icon ?? this.icon,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
      iconMaskBaseUri: iconMaskBaseUri ?? this.iconMaskBaseUri,
      name: name ?? this.name,
      openingHours: openingHours ?? this.openingHours,
      photos: photos ?? this.photos,
      placeId: placeId ?? this.placeId,
      plusCode: plusCode ?? this.plusCode,
      priceLevel: priceLevel ?? this.priceLevel,
      rating: rating ?? this.rating,
      reference: reference ?? this.reference,
      scope: scope ?? this.scope,
      tags: tags ?? this.tags,
      userRatingsTotal: userRatingsTotal ?? this.userRatingsTotal,
      permanentlyClosed: permanentlyClosed ?? this.permanentlyClosed,
      vicinity: vicinity ?? this.vicinity,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  Map<String, dynamic> toJson() => {
        'business_status': businessStatus,
        'geometry': geometry?.toJson(),
        'icon': icon,
        'icon_background_color': iconBackgroundColor,
        'icon_mask_base_uri': iconMaskBaseUri,
        'name': name,
        'opening_hours': openingHours.toJson(),
        'photos': photos?.map((x) => x.toJson()).toList(),
        'place_id': placeId,
        'plus_code': plusCode?.toJson(),
        'price_level': priceLevel,
        'rating': rating,
        'reference': reference,
        'scope': scope,
        'tags': tags,
        'user_ratings_total': userRatingsTotal,
        'vicinity': vicinity,
        'permanently_closed': permanentlyClosed,
        'image_url': imageUrl,
      };
}

@immutable
class OpeningHours {
  const OpeningHours({required this.openNow});

  const OpeningHours.closed() : openNow = false;

  const OpeningHours.opened() : openNow = true;

  factory OpeningHours.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const OpeningHours.closed();
    }
    return OpeningHours(
      openNow: json['open_now'] as bool,
    );
  }
  final bool openNow;

  Map<String, dynamic> toJson() => {'open_now': openNow};
}

@immutable
class PlusCode {
  const PlusCode({
    required this.compoundCode,
    required this.globalCode,
  });

  const PlusCode.empty()
      : compoundCode = '',
        globalCode = '';

  factory PlusCode.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PlusCode.empty();
    }
    return PlusCode(
      compoundCode: json['compound_code'] as String,
      globalCode: json['global_code'] as String,
    );
  }
  final String compoundCode;
  final String globalCode;

  Map<String, dynamic> toJson() => {
        'compound_code': compoundCode,
        'global_code': globalCode,
      };
}

class Tag extends Equatable {
  const Tag({
    required this.name,
    required this.imageUrl,
  });

  factory Tag.fromJson(Map<String, dynamic> map) {
    return Tag(
      name: map['name'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  final String name;
  final String imageUrl;

  @override
  List<Object?> get props => <Object?>[name, imageUrl];

  Map<String, dynamic> toJson() => {
        'name': name,
        'image_url': imageUrl,
      };
}
