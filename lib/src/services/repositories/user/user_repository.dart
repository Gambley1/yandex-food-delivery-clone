import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/models/models.dart';
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:papa_burger/src/services/repositories/user/user.dart';
import 'package:papa_burger/src/services/storage/storage.dart';
import 'package:papa_burger/src/views/pages/cart/state/cart_bloc.dart';
import 'package:papa_burger/src/views/pages/cart/state/selected_card_notifier.dart';
import 'package:papa_burger/src/views/pages/main/state/location_bloc.dart';
import 'package:papa_burger/src/views/pages/main/state/main_bloc.dart';

@immutable
class UserRepository implements BaseUserRepository {
  const UserRepository({
    required UserApi userApi,
  }) : _userApi = userApi;

  final UserApi _userApi;

  @override
  Future<User> login(String email, String password) async {
    final user = await _userApi.login(email, password);
    LocalStorage()
      ..saveUser(user.toJson())
      ..saveCookieUserCredentials(user.uid, user.email, user.username);
    return user;
  }

  @override
  Future<User> register(
    String name,
    String email,
    String password, {
    String profilePicture = '',
  }) async {
    final user = await _userApi.register(
      name,
      email,
      password,
      profilePitcture: profilePicture,
    );
    LocalStorage()
      ..saveUser(user.toJson())
      ..saveCookieUserCredentials(user.uid, user.email, user.username);
    return user;
  }

  @override
  Future<void> logout() async {
    await CartBloc().removeAllItems();
    LocalStorage().deleteUserCookies();
    SelectedCardNotifier().deleteCardSelection();
    LocationNotifier().clearLocation();
    MainBloc().clearAllRestaurants;
  }
}
