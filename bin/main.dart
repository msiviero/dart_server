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
        return Response(body: 'Hello, world');
      },
    ))
    ..add(Route(
      method: 'POST',
      path: '/hello',
      handler: (request) async {
        final content = await request.body;
        print(content);
        return Response(
          body: '',
          statusCode: HttpStatus.accepted,
        );
      },
    ))
    ..start();
}
