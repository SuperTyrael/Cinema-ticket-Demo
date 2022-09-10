import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;

import 'mime_type_resolver.dart';

///Starts a server on `http://localhost:[port]/`.
///
///**NOTE for iOS**: For the iOS Platform, you need to add the `NSAllowsLocalNetworking` key with `true` in the `Info.plist` file (See [ATS Configuration Basics](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW35)):
///```xml
///<key>NSAppTransportSecurity</key>
///<dict>
///    <key>NSAllowsLocalNetworking</key>
///    <true/>
///</dict>
///```
///The `NSAllowsLocalNetworking` key is available since **iOS 10**.
Future<HttpServer> createAssetsServer({String? prefix}) async {
  final server = await HttpServer.bind('127.0.0.1', 0);
  server.listen((HttpRequest request) async {
    Uint8List body = Uint8List(0);

    var path = request.requestedUri.path;
    path = (path.startsWith('/')) ? path.substring(1) : path;
    if (prefix != null) {
      path = prefix + path;
    }
    path += (path.endsWith('/')) ? 'index.html' : '';

    try {
      body = (await rootBundle.load(path)).buffer.asUint8List();
    } catch (e) {
      print(e.toString());
      request.response.close();
      return;
    }

    var contentType = ['text', 'html'];
    if (!request.requestedUri.path.endsWith('/') &&
        request.requestedUri.pathSegments.isNotEmpty) {
      var mimeType = MimeTypeResolver.lookup(request.requestedUri.path);
      if (mimeType != null) {
        contentType = mimeType.split('/');
      }
    }

    request.response.headers.contentType =
        ContentType(contentType[0], contentType[1], charset: 'utf-8');
    request.response.add(body);
    request.response.close();
  });

  return server;
}
