import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'
    show FontAwesomeIcons;
import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/views/pages/cart/components/cart_bottom_app_bar.dart';
import 'package:papa_burger/src/views/pages/cart/components/cart_items_list_view.dart';
import 'package:papa_burger/src/views/pages/cart/components/choose_payment_modal_bottom_sheet.dart';
import 'package:papa_burger/src/views/pages/cart/components/progress_bar_modal_bottom_sheet.dart';
import 'package:papa_burger/src/views/pages/cart/state/cart_bloc.dart';
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';
import 'package:papa_burger/src/views/pages/main/services/services.dart';
import 'package:papa_burger/src/views/widgets/widgets.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  Restaurant _restaurant = const Restaurant.empty();

  @override
  void initState() {
    super.initState();
    CartBloc()
        .getRestaurant(CartBloc().value.restaurantPlaceId)
        .then((restaurant) {
      setState(() => _restaurant = restaurant);
    });
  }

  Widget _buildCartItemsListView(
    BuildContext context,
    Restaurant restaurant,
    Cart cart,
  ) {
    void decreaseQuantity(BuildContext context, Item item) {
      CartBloc().decreaseQuantity(context, item, restaurant: restaurant);
    }

    void increaseQuantity(Item item) {
      CartBloc().increaseQuantity(item);
    }

    CartItemsListView buildWithCartItems(
      void Function(BuildContext context, Item item) decrementQuantity,
      void Function(Item item) increaseQuantity,
      Map<Item, int> itemsTest,
    ) {
      return CartItemsListView(
        decreaseQuantity: decreaseQuantity,
        increaseQuantity: increaseQuantity,
        cartItems: itemsTest,
        allowIncrease: CartBloc().allowIncrease,
      );
    }

    SliverToBoxAdapter buildEmptyCart(BuildContext context) =>
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 240),
            child: Column(
              children: [
                const KText(
                  text: 'Your Cart is Empty',
                  size: 26,
                  fontWeight: FontWeight.bold,
                ),
                OutlinedButton(
                  onPressed: () {
                    context.navigateToMainPage();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIcon(
                        icon: FontAwesomeIcons.cartShopping,
                        type: IconType.simpleIcon,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      KText(
                        text: 'Explore',
                        size: 22,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    if (cart.cartEmpty) return buildEmptyCart(context);
    return buildWithCartItems(
      decreaseQuantity,
      increaseQuantity,
      cart.cartItems,
    );
  }

  Future<void> _showCheckoutModalBottomSheet(BuildContext context) {
    final locationService = LocationService();
    final cardNotifier = SelectedCardNotifier();

    late final locationNotifier = locationService.locationNotifier;

    SliverToBoxAdapter buildRow(
      BuildContext context,
      String title,
      String subtitle,
      IconData? icon,
      void Function()? onTap,
    ) {
      return SliverToBoxAdapter(
        child: ListTile(
          onTap: onTap,
          horizontalTitleGap: 0,
          contentPadding: const EdgeInsets.only(
            top: 12,
            left: 12,
            right: 12,
          ),
          leading: icon == null
              ? null
              : CustomIcon(
                  icon: icon,
                  size: 20,
                  type: IconType.simpleIcon,
                ),
          title: LimitedBox(
            maxWidth: 260,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KText(maxLines: 1, text: title),
                KText(
                  maxLines: 1,
                  text: subtitle,
                  size: 14,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 12),
                const Divider(
                  height: 2,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          trailing: const CustomIcon(
            icon: Icons.arrow_forward_ios_outlined,
            type: IconType.simpleIcon,
            size: 14,
          ),
        ),
      );
    }

    SliverToBoxAdapter buildRowWithInfo(
      BuildContext context, {
      bool forAddressInfo = true,
    }) {
      SliverToBoxAdapter addressInfo() => buildRow(
            context,
            'street ${locationNotifier.value}',
            'Leave an order comment please 🙏',
            FontAwesomeIcons.house,
            () => context.navigateToGoolgeMapView(),
          );

      SliverToBoxAdapter deliveryTimeInfo() => buildRow(
            context,
            'Delivery 15-30 minutes',
            'But it might even be faster',
            FontAwesomeIcons.clock,
            () => context.navigateToMainPage(),
          );

      if (forAddressInfo) return addressInfo();
      return deliveryTimeInfo();
    }

    Future<void> showChoosePaymentModalBottomSheet(BuildContext context) =>
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          ),
          builder: (context) {
            return ChoosePaymentModalBottomSheet();
          },
        );

    Future<void> showOrderProgressModalBottomSheet(BuildContext context) =>
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
          ),
          builder: (context) {
            return const OrderProgressBarModalBottomSheet();
          },
        );

    return context.showCustomModalBottomSheet(
      initialChildSize: 0.5,
      children: [
        buildRowWithInfo(context),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 12,
          ),
        ),
        buildRowWithInfo(context, forAddressInfo: false),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 6,
          ),
        ),
        ValueListenableBuilder<CreditCard>(
          valueListenable: cardNotifier,
          builder: (context, selectedCard, _) {
            final noSeletction = selectedCard == const CreditCard.empty();
            return SliverToBoxAdapter(
              child: ListTile(
                onTap: () => showChoosePaymentModalBottomSheet(context),
                title: KText(
                  text: noSeletction
                      ? 'Choose credit card'
                      : 'VISA •• '
                          '${selectedCard.number.characters.getRange(15, 19)}',
                  color: noSeletction ? Colors.red : Colors.black,
                ),
                trailing: const CustomIcon(
                  icon: Icons.arrow_forward_ios_sharp,
                  type: IconType.simpleIcon,
                  size: 14,
                ),
              ),
            );
          },
        ),
      ],
      isScrollControlled: true,
      scrollableSheet: true,
      bottomAppBar: ValueListenableBuilder(
        valueListenable: cardNotifier,
        builder: (context, selectedCard, _) {
          return CartBottomAppBar(
            info: 'Total',
            title: 'Pay',
            onTap: selectedCard == const CreditCard.empty()
                ? () => showChoosePaymentModalBottomSheet(context)
                : () {
                    showOrderProgressModalBottomSheet(context);
                  },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      bottomNavigationBar: CartBottomAppBar(
        info: '30-40 min',
        title: 'Right, next',
        onTap: () => _showCheckoutModalBottomSheet(context),
      ),
      onPopInvoked: (didPop) {
        if (!didPop) return;
        if (CartBloc().value.restaurantPlaceId.isEmpty) {
          context.navigateToMainPage();
        } else {
          context.navigateToMenu(context, _restaurant, fromCart: true);
        }
      },
      body: ValueListenableBuilder<Cart>(
        valueListenable: CartBloc(),
        builder: (context, cart, _) {
          return CustomScrollView(
            scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
            slivers: [
              CartAppBar(cart: cart, restaurant: _restaurant),
              _buildCartItemsListView(context, _restaurant, cart),
            ],
          );
        },
      ),
    );
  }
}

class CartAppBar extends StatelessWidget {
  const CartAppBar({
    required this.cart,
    required this.restaurant,
    super.key,
  });

  final Restaurant restaurant;
  final Cart cart;

  Future<void> _showClearCartDialog({
    required BuildContext context,
    required Restaurant restaurant,
  }) =>
      showCustomDialog(
        context,
        onTap: () {
          context.pop(withHaptickFeedback: true);
          CartBloc().removeAllItems().then((_) {
            CartBloc().removePlaceIdInCacheAndCart();
            context.navigateToMenu(context, restaurant, fromCart: true);
          });
        },
        alertText: 'Clear the Busket?',
        actionText: 'Clear',
      );

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: const KText(
        text: 'Cart',
        size: 26,
        fontWeight: FontWeight.bold,
      ),
      leading: CustomIcon(
        icon: FontAwesomeIcons.arrowLeft,
        type: IconType.iconButton,
        onPressed: () => cart.restaurantPlaceId.isEmpty
            ? context.navigateToMainPage()
            : context.navigateToMenu(context, restaurant, fromCart: true),
      ),
      actions: cart.cartEmpty
          ? null
          : [
              CustomIcon(
                icon: FontAwesomeIcons.trash,
                size: 20,
                onPressed: () => _showClearCartDialog(
                  context: context,
                  restaurant: restaurant,
                ),
                type: IconType.iconButton,
              ),
            ],
      scrolledUnderElevation: 2,
      expandedHeight: 80,
      excludeHeaderSemantics: true,
      backgroundColor: Colors.white,
      pinned: true,
    );
  }
}
