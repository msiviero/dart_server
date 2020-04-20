import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

class Application {
  final int port;
  final Router _router = Router();

  Application({@required this.port});

  void add(Route route) {
    _router.add(route);
  }

  Future<void> start() async {
    final host = '0.0.0.0';
    final requests = await HttpServer.bind(host, port);
    print('Started on port $host:$port');

    await for (final request in requests) {
      try {
        final route = _router.match(request.method, request.uri.path);
        if (route != null) {
          final response = await route.handler(Request(request));
          final httpResponse = request.response
            ..statusCode = response.statusCode
            ..headers.contentType = response.contentType ??
                ContentType('text', 'plain', charset: 'utf-8');
          await httpResponse.write(response.body);
          await httpResponse.close();
        } else {
          _sendNotFound(request);
        }
      } catch (e) {
        _internalError(request, e);
      }
    }
  }

  void _sendNotFound(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Not found')
      ..close();
  }

  void _internalError(HttpRequest request, Exception e) {
    request.response
      ..statusCode = HttpStatus.internalServerError
      ..write(e)
      ..close();
  }
}

class Router {
  final Map<String, List<Route>> _routes = {};

  void add(Route route) {
    final method = route.method.toLowerCase();
    final methodRoutes = _routes[method] ?? [];
    methodRoutes.add(route);
    _routes[method] = methodRoutes;
  }

  Route match(String method, String path) =>
      (_routes[method.toLowerCase()] ?? [])
          .firstWhere((route) => route.matchPath(path), orElse: () => null);
}

class Route {
  final RouteHandler<void> handler;
  final String method;
  final String path;

  Route({
    @required this.handler,
    @required this.method,
    @required this.path,
  });

  bool matchPath(String path) => this.path == path;

  @override
  bool operator ==(other) =>
      (other is Route && other.method == method && other.path == path);
}

typedef RouteHandler<T> = FutureOr<Response> Function(Request request);

class Request {
  final HttpRequest originalRequest;

  Request(this.originalRequest);

  Future<String> get body async {
    return utf8.decoder.bind(originalRequest).join();
  }
}

class Response {
  final String body;
  final int statusCode;
  final ContentType contentType;

  Response({
    this.body = '',
    this.statusCode = HttpStatus.accepted,
    this.contentType,
  });
}
