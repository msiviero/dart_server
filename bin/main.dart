import 'dart:convert';
import 'dart:io';

import 'package:dart_server/application.dart';

void main(final List<String> args) {
  Application(
    port: int.parse(Platform.environment['PORT'] ?? '8080'),
  )
    ..add(Route(
      method: 'GET',
      path: '/hello',
      handler: (request) {
        request.response
          ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
          ..write('Hello, world')
          ..close();
      },
    ))
    ..add(Route(
      method: 'POST',
      path: '/hello',
      handler: (request) async {
        final content = await utf8.decoder.bind(request).join();
        print(content);

        final response = request.response
          ..headers.contentType = ContentType('text', 'plain', charset: 'utf-8')
          ..statusCode = HttpStatus.accepted;

        await response.flush();
        await response.close();
      },
    ))
    ..start();
}
