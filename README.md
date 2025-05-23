<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

## Features

A lightweight api to fetch and interpret data from the Home.InfoPoint service.

## Getting started

Depend on the package inside your pubspec.yaml:

```yaml
dependencies:
    home_info_point_client:
        git:
            url: https://github.com/Venatrixx/home_info_point_client
```
(The package itself contains the http and html dependencies.)

## Usage

### 1. Setup the Home.InfoPoint (Hip) client:
```dart
final client = HipClient(HipConfig(schoolCode: 'my-school', username: '123456', password: 'ABCDEF'));
```
(You typically find the school code inside the url: https://homeinfopoint.de/[schoolCode])

&nbsp;

### 2. (optional) Check if the credentials are valid and a connection can be established:
```dart
bool isValid = await client.verify();
```
&nbsp;

### 3. Fetch the data from the server:
```dart
await client.fetch();
```
&nbsp;

### 4. Get the interpreted data:
```dart
dynamic data = await client.asJson();
```
&nbsp;

**Have fun!**

&nbsp;
&nbsp;
&nbsp;

### Any questions left or need help with the package?
Contact me via *info@nice-2know.de*!
