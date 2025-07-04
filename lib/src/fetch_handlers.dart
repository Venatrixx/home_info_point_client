import 'dart:io';

import 'package:home_info_point_client/home_info_point_client.dart';

part 'fetch.dart';

Future<HttpClientResponse> fetchData(HipConfig config) async {
  try {
    return await _fetchDataMethod(config).timeout(config.timeoutDuration);
  } catch (e) {
    if (e is OSError || e is SocketException || e is HttpException) {
      return await _fetchDataMethod(config).timeout(config.timeoutDuration);
    }
    rethrow;
  }
}

Future<bool> verifyCredentials(HipConfig config) async {
  try {
    return await _verifyCredentialsMethod(config).timeout(config.timeoutDuration);
  } catch (e) {
    if (e is OSError || e is SocketException || e is HttpException) {
      return await _verifyCredentialsMethod(config).timeout(config.timeoutDuration);
    }
    rethrow;
  }
}
