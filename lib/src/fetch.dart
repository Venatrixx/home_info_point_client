part of 'fetch_handlers.dart';

Future<HttpClientResponse> _fetchDataMethod(HipConfig config) async {
  String cookieSessionId = "";

  HttpClient client = HttpClient();

  // get request on default page to receive session cookie
  HttpClientRequest clientRequest = await client.getUrl(
    Uri.https('homeinfopoint.de', '/${config.schoolCode}/default.php'),
  );
  HttpClientResponse clientResponse = await clientRequest.close();

  cookieSessionId = clientResponse.cookies.firstWhere((element) => element.name == "PHPSESSID").value;

  // post request with credentials
  var uri = Uri.https('homeinfopoint.de', '/${config.schoolCode}/login.php');

  HttpClientRequest clientRequest2 = await client.postUrl(uri);
  clientRequest2.cookies.add(Cookie("PHPSESSID", cookieSessionId));
  clientRequest2.headers.contentType = ContentType("application", "x-www-form-urlencoded", charset: "utf-8");
  clientRequest2.write("username=${config.username}&password=${config.password}");

  HttpClientResponse clientResponse2 = await clientRequest2.close();

  // catch errors
  String postLocation = clientResponse2.headers.value(HttpHeaders.locationHeader)!;

  if (!postLocation.contains("getdata.php")) {
    client.close(force: true);
    print(clientResponse2.headers);
    throw Exception("Unable to verify credentials.");
  }

  // continue with get request and receive html

  HttpClientRequest clientRequest3 = await client.getUrl(
    uri.resolve(clientResponse2.headers.value(HttpHeaders.locationHeader)!),
  );
  clientRequest3.cookies.add(Cookie('PHPSESSID', cookieSessionId));

  final clientResponse3 = await clientRequest3.close();

  if (clientResponse3.statusCode != 200) {
    client.close(force: true);
    throw Exception("Final response code not `200.`");
  }

  return clientResponse3;
}

Future<bool> _verifyCredentialsMethod(HipConfig config) async {
  String cookieSessionId = "";

  HttpClient client = HttpClient();

  // get request on default page to receive session cookie

  HttpClientRequest clientRequest = await client.getUrl(
    Uri.https('homeinfopoint.de', '/${config.schoolCode}/default.php'),
  );
  HttpClientResponse clientResponse = await clientRequest.close();

  cookieSessionId = clientResponse.cookies.firstWhere((element) => element.name == "PHPSESSID").value;

  // post request with credentials
  var uri = Uri.https('homeinfopoint.de', '/${config.schoolCode}/login.php');

  HttpClientRequest clientRequest2 = await client.postUrl(uri);
  clientRequest2.cookies.add(Cookie("PHPSESSID", cookieSessionId));
  clientRequest2.headers.contentType = ContentType("application", "x-www-form-urlencoded", charset: "utf-8");
  clientRequest2.write("username=${config.username}&password=${config.password}");

  HttpClientResponse clientResponse2 = await clientRequest2.close();

  // determine result
  String postLocation = clientResponse2.headers.value(HttpHeaders.locationHeader)!;

  if (postLocation.contains("getdata.php")) {
    client.close(force: true);
    return true;
  }

  client.close(force: true);
  return false;
}
