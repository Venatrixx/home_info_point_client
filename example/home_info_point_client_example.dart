import 'package:home_info_point_client/home_info_point_client.dart';

void main() async {
  // create an instance of the [HipClient] and configure it with a [HipConfig] object
  final client = HipClient(HipConfig(schoolCode: 'my-school', username: '123456', password: 'ABCDEF'));

  // optional: verify the credentials
  await client.verify(); // true or false

  // always fetch the data before trying to access it
  try {
    await client.fetch();
  } catch (e) {
    // handle errors...
  }

  // retrieve the data
  dynamic data = await client.asJson();
  print(data);
  // or..
  String? stringData = await client.asJsonString();
  print(stringData);

  // you can get rid of the credentials afterwards
  client.disposeCredentials();
}
