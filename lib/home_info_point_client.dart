library;

import 'package:home_info_point_client/src/hip_client.dart';

export 'src/hip_client.dart' show HipClient, HipConfig, interpretData;
export 'src/fetch_handlers.dart' show verifyCredentials;

void main() async {
  final client = HipClient(
    HipConfig(schoolCode: 'rwg-waren', username: '281628', password: 'MRUVFE'),
  );

  await client.fetch();

  print(await client.asJson());
}
