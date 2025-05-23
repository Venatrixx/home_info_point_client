import 'dart:convert';
import 'dart:io';

import 'package:html/parser.dart' as parser;

part 'fetch.dart';
part 'hip_config.dart';
part 'interpreter.dart';

class HipClient {
  /// Object used to configure the connection to the Home.InfoPoint server.
  late HipConfig config;

  HttpClientResponse? _response;

  HipClient(this.config);

  /// Method to fetch the data from Home.InfoPoint server.
  ///
  /// Can throw errors, so wrap it inside a try-catch block.
  /// ```dart
  /// try{
  ///   await client.fetch();
  /// } catch (_){
  ///   // show error message and aboard process
  ///   return;
  /// }
  /// final data = client.asJson();
  /// ```
  Future<void> fetch() async {
    _response = await fetchData(config);
  }

  /// Verifies the credentials provided by the [HipConfig] object and returns true, if they are valid.
  ///
  /// Returns `false` even if an error occurred during the fetch. Therefore, a return value of `false` does not indicate
  /// that the credentials where incorrect per se.
  Future<bool> verify() => verifyCredentials(config);

  /// Get the data from the server response as `json`.
  ///
  /// **Remember** to call [fetch] before trying to get the json data, as this will return ``null`` otherwise.
  dynamic asJson() async {
    if (_response == null) return null;
    return interpretData((await _response!.transform(utf8.decoder).toList()).first);
  }

  /// Get the data from the server as a `json` string.
  ///
  /// **Remember** to call [fetch] before trying to get the json data, as this will return ``null`` otherwise.
  Future<String?> asJsonString() async {
    if (_response == null) return null;
    return jsonEncode(interpretData((await _response!.transform(utf8.decoder).toList()).first));
  }

  /// Use this method to override the clients config, effectively getting rid of the stored credentials.
  void disposeCredentials() {
    config = HipConfig(schoolCode: '', username: '', password: '');
  }
}
