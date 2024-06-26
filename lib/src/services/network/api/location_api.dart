// ignore_for_file: cascade_invocations, avoid_dynamic_calls, lines_longer_than_80_chars

import 'package:dio/dio.dart' show Dio;
import 'package:flutter/foundation.dart' show immutable;
import 'package:geolocator/geolocator.dart'
    show Geolocator, LocationAccuracy, LocationPermission, Position;
import 'package:papa_burger/src/services/network/api/api.dart';
import 'package:shared/shared.dart';

@immutable
class LocationApi {
  LocationApi({
    UrlBuilder? urlBuilder,
    Dio? dio,
  })  : _urlBuilder = urlBuilder ?? UrlBuilder(),
        _dio = dio ?? Dio();

  final UrlBuilder _urlBuilder;
  final Dio _dio;

  static const int _time = 15;
  static const bool _forceAndroidLocationManager = true;
  static const LocationAccuracy _desiredAccuracy = LocationAccuracy.high;
  static const Duration _timeLimit = Duration(seconds: _time);

  Future<Position> determineCurrentPosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission has been denied');
      }
    }
    return _getCurrentPosition();
  }

  Future<Position> _getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: _desiredAccuracy,
      forceAndroidLocationManager: _forceAndroidLocationManager,
      timeLimit: _timeLimit,
    );
  }

  Future<List<AutoComplete>> getAutoComplete({required String query}) async {
    final url = _urlBuilder.buildMapAutoCompleteUrl(query: query);
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
      final data = response.data;
      if (data == null) {
        throw Exception('Response is empty');
      }
      final status = data['status'];
      if (status == 'ZERO_RESULTS') {
        logW(
          'Indicating that the search was successful but returned no results.',
        );
        return [];
      }
      if (status == 'INVALID_REQUEST') {
        logW(
          'Indicating the API request was malformed, generally due to the missing input parameter. $status',
        );
        return [];
      }
      if (status == 'OVER_QUERY_LIMIT') {
        logW(
          'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. $status',
        );
        return [];
      }
      if (status == 'REQUEST_DENIED') {
        logW('The request is missing an API key. $status');
        return [];
      }
      if (status == 'UNKNOWN_ERROR') {
        logE('Unknown error. $status');
        return [];
      }
      final predictions = data['predictions'] as List;
      logI(response.data);
      return predictions
          .map<AutoComplete>(
            (e) => AutoComplete.fromJson(e as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      logE(e.toString());
      return [];
    }
  }

  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final url = _urlBuilder.buildGetPlaceDetailsUrl(placeId: placeId);

      final response = await _dio.get<Map<String, dynamic>>(url);
      final data = response.data;
      if (data == null) {
        throw Exception('Response is empty');
      }
      final status = data['status'];
      if (status == 'ZERO_RESULTS') {
        logW(
          'Indicating that the search was successful but returned no results.',
        );
        return null;
      }
      if (status == 'INVALID_REQUEST') {
        logW(
          'Indicating the API request was malformed, generally due to the missing input parameter. $status',
        );
        return null;
      }
      if (status == 'OVER_QUERY_LIMIT') {
        logW(
          'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. $status',
        );
        return null;
      }
      if (status == 'REQUEST_DENIED') {
        logW('The request is missing an API key. $status');
        return null;
      }
      if (status == 'UNKNOWN_ERROR') {
        logE('Unknown error. $status');
        return null;
      }
      final result = data['result'];
      if (result == null) return null;
      final details = PlaceDetails.fromJson(result as Map<String, dynamic>);
      return details;
    } catch (e) {
      logE(e.toString());
      return null;
    }
  }

  Future<String> getFormattedAddress(double lat, double lng) async {
    final url = _urlBuilder.buildGeocoderUrl(lat: lat, lng: lng);
    try {
      final response = await _dio.get<Map<String, dynamic>>(url);
      final data = response.data;
      if (data == null) {
        throw Exception('Response is empty');
      }
      final status = data['status'];
      if (status == 'ZERO_RESULTS') {
        // logger.w(
        //   'Indicating that the search was successful but returned no results.',
        // );
        return '';
      }
      if (status == 'INVALID_REQUEST') {
        // logger.w(
        //   'Indicating the API request was malformed, generally due to the missing input parameter. $status',
        // );
        return '';
      }
      if (status == 'OVER_QUERY_LIMIT') {
        // logger.w(
        //   'The monthly \$200 credit, or a self-imposed usage cap, has been exceeded. $status',
        // );
        return '';
      }
      if (status == 'REQUEST_DENIED') {
        // logger.w('The request is missing an API key. $status');
        return '';
      }
      if (status == 'UNKNOWN_ERROR') {
        // logger.e('Unknown error. $status');
        return '';
      }
      final formattedAddress =
          data['results'][1]['formatted_address'] as String;
      logW(formattedAddress);
      logW((lat: lat, lng: lng));
      return formattedAddress;
    } catch (e) {
      logE(e.toString());
      rethrow;
    }
  }
}
