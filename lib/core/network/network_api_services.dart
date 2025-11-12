import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';
import '../../router/app_pages.dart';
import '../constants/app_constants.dart';
import '../errors/app_exceptions.dart';
import '../local/shared_preferences_helper.dart';
import 'base_api_services.dart';

/// Class for handling network API requests.
class NetworkApiService implements BaseApiServices {
  /// Sends a GET request to the specified [url] and returns the response.
  ///
  /// Throws a [NoInternetException] if there is no internet connection.
  /// Throws a [FetchDataException] if the network request times out.

  final Dio _dio = Dio();

  NetworkApiService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }


  @override
  Future<dynamic> getApi(String url) async {
    if (kDebugMode) {
      print(
          "AccessToken==>Bearer ${SharedPreferencesHelper.getString(AppConstants.ACCESS_TOKEN)}");
      print("Get_api==>$url");
    }
    dynamic responseJson;
    Map<String, String> headers = {
      'Device-ID':
          "${SharedPreferencesHelper.getString(AppConstants.DEVICE_ID)}",
    };
    try {
      /*final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );
      responseJson = returnResponse(response);*/
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Device-ID': SharedPreferencesHelper.getString(AppConstants.DEVICE_ID),
          },
        ),
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw NoInternetException('');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }

    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  /// Sends a POST request to the specified [url] with the provided [data]
  /// and returns the response.
  ///
  /// Throws a [NoInternetException] if there is no internet connection.
  /// Throws a [FetchDataException] if the network request times out.
  @override
  Future<dynamic> fetchTokenApi(String url, dynamic data) async {

    if (kDebugMode) {
      print("fetchTokenApi==>$url");
    }
    dynamic responseJson;
    try {
      debugPrint("Body==>$data", wrapWidth: 1024);
      debugPrint("BodyTYPE==>${data.runtimeType}");


      Response response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        ),
      );
      if (kDebugMode) {
        print("Status_code =>> ${response.statusCode}");
        // print("jsonDecodeResponse =>> ${jsonDecode(response.data)}");
        print("Response =>> ${response.data['access_token']}");
      }
      responseJson = _returnResponse(response);


    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    if (kDebugMode) {
      print("STATUS_CODE-->${response.statusCode}");
    }

    switch (response.statusCode) {
      case 200:
        // dynamic responseJson = jsonDecode(response.data);
        dynamic responseJson = response.data;
        return responseJson;
      // case 201:
      //   dynamic responseJson = jsonDecode(response.body);
      //   return responseJson;
      case 400:
        dynamic responseJson = jsonDecode(response.data);
        return responseJson;
      case 401:
        // debugPrint("-----401-----");
        // GoRouter.of(navigatorKey.currentContext!).go(AppPages.URL_VERIFICATION);
        if (navigatorKey.currentContext != null) {
          GoRouter.of(navigatorKey.currentContext!)
              .go(AppPages.LOGIN);
        } else {
          print("Navigator context is null");
        }
        return null;
      case 500:
        dynamic responseJson = jsonDecode(response.data);
        return responseJson;
      case 404:
        throw UnauthorisedException(response.data.toString());
      default:
        throw FetchDataException(
            'Error occurred while communicating with server');
    }
  }

  @override
  Future postApi(String url, dynamic data,dynamic header) async {

    if (kDebugMode) {
      print("Post_api==>$url");
    }
    dynamic responseJson;
    try {
      debugPrint("Body==>$data", wrapWidth: 1024);
      debugPrint("BodyTYPE==>${data.runtimeType}");


      Response response = await _dio.post(
        url,
        data: data,
        options: Options(
          headers: header,
        ),
      );
      if (kDebugMode) {
        print("Status_code =>> ${response.statusCode}");
        // print("jsonDecodeResponse =>> ${jsonDecode(response.data)}");
        print("Response =>> ${response.data}");
      }
      responseJson = _returnResponse(response);


    } on SocketException {
      throw NoInternetException('No Internet Connection');
    } on TimeoutException {
      throw FetchDataException('Network Request time out');
    }
    if (kDebugMode) {
      print(responseJson);
    }
    return responseJson;
  }
}
