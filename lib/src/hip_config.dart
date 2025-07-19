part of 'hip_client.dart';

class HipConfig {
  /// Name of the school inside the Home.InfoPoint service.
  ///
  /// Found inside of the URL: https://homeinfopoint.de/[schoolCode]
  final String schoolCode;

  /// Username of the user.
  final String username;

  /// Password of the user.
  final String password;

  /// A custom timeout duration to use when fetching the data from HomeInfo.Point.
  ///
  /// Defaults to 4 seconds.
  final Duration timeoutDuration;

  HipConfig({
    required this.schoolCode,
    required this.username,
    required this.password,
    this.timeoutDuration = const Duration(seconds: 4),
  });

  HipConfig.empty() : schoolCode = '', username = '', password = '', timeoutDuration = const Duration(seconds: 4);
}
