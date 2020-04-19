import 'dart:io';

class Application {
  int port;

  Application({this.port});

  void start() async {
    final requests = await HttpServer.bind('0.0.0.0', port);
    await for (var request in requests) {
      _processRequest(request);
    }
  }

  void _processRequest(HttpRequest request) {
    request.response
      ..headers.contentType = ContentType('text', 'plain')
      ..write('Hello')
      ..close();
  }
}
