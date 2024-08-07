import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/foundation.dart' show immutable;
import 'package:yandex_food_api/client.dart';

@immutable
class Cart extends Equatable {
  const Cart({
    this.restaurantPlaceId = '',
    this.cartItems = const <MenuItem, int>{},
  });

  final String restaurantPlaceId;
  final Map<MenuItem, int> cartItems;

  static const _minimumSubTotal = 30;
  static const _deliveryFee = 10;

  Cart copyWith({
    String? restaurantPlaceId,
    Map<MenuItem, int>? cartItems,
  }) =>
      Cart(
        restaurantPlaceId: restaurantPlaceId ?? this.restaurantPlaceId,
        cartItems: cartItems ?? this.cartItems,
      );

  Set<MenuItem> get items => cartItems.keys.toSet();

  bool get isCartEmpty => items.toList().isEmpty;
  int quantity(MenuItem item) => cartItems[item] ?? 0;

  double get _subTotal {
    double calculatePriceWithQuantity(MenuItem item) {
      final itemQuantity = cartItems[item]!;
      if (item.discount == 0) return item.price * itemQuantity;
      final priceWithDiscount =
          item.price - (item.price * (item.discount / 100));
      return priceWithDiscount * itemQuantity;
    }

    return items.fold<double>(
      0,
      (total, current) => total + calculatePriceWithQuantity(current),
    );
  }

  int get deliveryFee => subTotalGreaterMinPrice ? 0 : _deliveryFee;

  bool get subTotalGreaterMinPrice => _subTotal > _minimumSubTotal;

  double _totalDelivery() {
    if (deliveryFee == 0) return _subTotal;
    return _subTotal + deliveryFee;
  }

  String get deliveryFeeToString => deliveryFee.currencyFormat();

  String totalDelivery() => _totalDelivery().currencyFormat();

  String totalDeliveryRound() => _totalDelivery().round().currencyFormat();

  double get _sumLeftToFreeDelivery => _minimumSubTotal - _subTotal;

  bool get isDeliveryFree => _sumLeftToFreeDelivery < 0;

  String get sumLeftToFreeDelivery => _sumLeftToFreeDelivery.currencyFormat();

  @override
  List<Object?> get props => [restaurantPlaceId, cartItems];
}
