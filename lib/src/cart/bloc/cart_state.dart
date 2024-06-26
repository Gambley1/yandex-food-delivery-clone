import 'package:shared/shared.dart';

abstract class CartState {
  const CartState();
}

class CartStateLoading extends CartState {
  const CartStateLoading();
}

class CartStateError extends CartState {
  const CartStateError(this.error);
  final Object error;
}

class CartStateEmpty extends CartState {
  const CartStateEmpty();
}

class CartStateWithItems extends CartState {
  const CartStateWithItems(this.cart);

  final Cart cart;
}
