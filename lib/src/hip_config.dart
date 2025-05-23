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

  HipConfig({
    required this.schoolCode,
    required this.username,
    required this.password,
  });
}
