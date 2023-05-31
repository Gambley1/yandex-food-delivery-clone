import 'package:flutter/foundation.dart' show immutable;
import 'package:papa_burger/src/restaurant.dart' show AutoComplete;

@immutable
abstract class LocationResult {
  const LocationResult();
}

@immutable
class LocationResultNoResults implements LocationResult {
  const LocationResultNoResults();
}

@immutable
class LocationResultEmpty implements LocationResult {
  const LocationResultEmpty();
}

@immutable
class LocationResultWithResults implements LocationResult {
  const LocationResultWithResults(this.autoCompletes);
  final List<AutoComplete> autoCompletes;
}

@immutable
class LocationResultLoading implements LocationResult {
  const LocationResultLoading();
}

@immutable
class LocationResultError implements LocationResult {
  const LocationResultError(this.error);
  final Object error;
}
