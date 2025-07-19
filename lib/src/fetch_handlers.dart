import 'dart:async';
import 'dart:io';

import 'package:home_info_point_client/home_info_point_client.dart';

part 'fetch.dart';

Future<T> fetchWithErrorHandling<T>(Future<T> Function() f) async {
  try {
    return await f.call().timeout(Duration(seconds: 3));
  } catch (e) {
    if (e is OSError || e is SocketException || e is HttpException || e is TimeoutException) {
      return await f.call().timeout(Duration(seconds: 4));
    }
    rethrow;
  }
}

Future<HttpClientResponse> fetchData(HipConfig config) async {
  try {
    return await _fetchDataMethod(config).timeout(config.timeoutDuration);
  } catch (e) {
    if (e is OSError || e is SocketException || e is HttpException || e is TimeoutException) {
      return await _fetchDataMethod(config).timeout(config.timeoutDuration);
    }
    rethrow;
  }
}

Future<bool> verifyCredentials(HipConfig config) async {
  try {
    return await _verifyCredentialsMethod(config).timeout(config.timeoutDuration);
  } catch (e) {
    if (e is OSError || e is SocketException || e is HttpException || e is TimeoutException) {
      return await _verifyCredentialsMethod(config).timeout(config.timeoutDuration);
    }
    rethrow;
  }
}
