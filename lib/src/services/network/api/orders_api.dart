import 'package:papa_burger/src/config/config.dart';
import 'package:papa_burger/src/services/repositories/orders/base_orders_repository.dart';
import 'package:papa_burger_server/api.dart' as server;
import 'package:shared/shared.dart';

class OrdersApi implements BaseOrdersRepository {
  OrdersApi({server.ApiClient? apiClient})
      : _apiClient = apiClient ?? server.ApiClient();

  final server.ApiClient _apiClient;

  Future<String> sendUserNotification(
    String uid, {
    required String orderId,
    required String status,
  }) async {
    try {
      var notificationMessage = '';
      if (status == 'Completed') {
        notificationMessage =
            'Your order №$orderId has been delivered! Check it out '
            'in your orders.';
      } else {
        notificationMessage =
            'Your order №$orderId has been canceled! Please contact '
            'emilzulufov.commercial@gmail.com if it was canceled by an '
            'accident.';
      }
      final message = _apiClient.sendUserNotification(uid, notificationMessage);
      return message;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<String> createOrder(
    String uid, {
    required String id,
    required String date,
    required String restaurantPlaceId,
    required String restaurantName,
    required String orderAddress,
    required String totalOrderSum,
    required String orderDeliveryFee,
  }) async {
    try {
      final orderId = await _apiClient
          .createUserOrder(
            uid,
            id: id,
            date: date,
            restaurantPlaceId: restaurantPlaceId,
            restaurantName: restaurantName,
            orderAddress: orderAddress,
            totalOrderSum: totalOrderSum,
            orderDeliveryFee: orderDeliveryFee,
          )
          .timeout(defaultTimeout);
      final message = await _apiClient.runBackgroundTimer(uid, orderId);
      logI('Run background timer message: $message');
      return orderId;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<String> deleteOrderDetails(
    String uid, {
    required String orderId,
  }) async {
    try {
      final message = await _apiClient
          .deleteOrderDetails(uid, orderId)
          .timeout(defaultTimeout);
      return message;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<List<OrderDetails>> getListOrderDetails(
    String uid, {
    String getIdentifier = 'list',
  }) async {
    try {
      final listOrderDetails = await _apiClient
          .getListOrderDetails(
            uid,
            getIdentifier: getIdentifier,
          )
          .timeout(defaultTimeout);
      return listOrderDetails.map<OrderDetails>(OrderDetails.fromDb).toList();
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<OrderDetails> getOrderDetails(
    String uid, {
    required String orderId,
    String getIdentifier = 'single',
  }) async {
    try {
      final orderDetails = await _apiClient
          .getOrderDetails(
            uid,
            orderId,
            getIdentifier: getIdentifier,
          )
          .timeout(defaultTimeout);
      return OrderDetails.fromDb(orderDetails);
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<String> updateOrderDetails(
    String uid, {
    required String id,
    String? status,
    String? date,
    String? restaurantPlaceId,
    String? restaurantName,
    String? orderAddress,
    String? totalOrderSum,
    String? orderDeliveryFee,
  }) async {
    try {
      final message = await _apiClient
          .updateOrderDetails(
            uid,
            id: id,
            status: status,
            date: date,
            restaurantPlaceId: restaurantPlaceId,
            restaurantName: restaurantName,
            orderAddress: orderAddress,
            totalOrderSum: totalOrderSum,
            orderDeliveryFee: orderDeliveryFee,
          )
          .timeout(defaultTimeout);
      return message;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<String> addOrderMenuItem(
    String uid, {
    required String name,
    required String quantity,
    required String price,
    required String imageUrl,
    required String orderDetailsId,
  }) async {
    try {
      final message = await _apiClient
          .addOrderMenuItem(
            uid,
            name: name,
            quantity: quantity,
            price: price,
            imageUrl: imageUrl,
            orderDetailsId: orderDetailsId,
          )
          .timeout(defaultTimeout);
      return message;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }

  @override
  Future<String> deleteOrderMenuItems(
    String uid, {
    required String orderDetailsId,
  }) async {
    try {
      final message = await _apiClient
          .deleteOrderMenuItems(
            uid,
            orderDetailsId,
          )
          .timeout(defaultTimeout);
      return message;
    } catch (error, stackTrace) {
      throw apiExceptionsFormatter(error, stackTrace);
    }
  }
}
