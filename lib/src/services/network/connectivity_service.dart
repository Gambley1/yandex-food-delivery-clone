import 'package:connectivity_plus/connectivity_plus.dart'
    show Connectivity, ConnectivityResult;
import 'package:flutter/foundation.dart' show immutable;

@immutable
class ConnectivityService {
  factory ConnectivityService() => _instance;

  const ConnectivityService._privateConstructor();
  static const ConnectivityService _instance =
      ConnectivityService._privateConstructor();

  Stream<ConnectivityResult> get connection => _connection();

  Stream<ConnectivityResult> _connection() =>
      Connectivity().onConnectivityChanged;
}
