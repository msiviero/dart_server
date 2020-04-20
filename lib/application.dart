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
      final route = _router.match(request.method, request.uri.path);
      if (route != null) {
        route.handler(request);
        continue;
      }
      _sendNotFound(request);
    }
  }

  void _sendNotFound(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Not found')
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

typedef RouteHandler<T> = T Function(HttpRequest request);

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
