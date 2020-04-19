import 'dart:io';

import 'package:dart_server/application.dart';

void main(final List<String> args) {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  Application(
    port: port,
  ).start();
}
