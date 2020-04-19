import 'package:dart_server/application.dart';
import 'package:test/test.dart';

void main() {
  test('Route should be tested for equality', () {
    final r1 = Route(
      method: 'GET',
      path: '/a',
      handler: (_) {},
    );

    final r2 = Route(
      method: 'GET',
      path: '/a',
      handler: (_) {},
    );

    expect(r1 == r2, equals(true));
  });

  test('Router should match simple rules', () {
    final route1 = Route(
      method: 'GET',
      path: '/a',
      handler: (_) {},
    );

    final route2 = Route(
      method: 'PUT',
      path: '/b',
      handler: (_) {},
    );

    final underTest = Router()..add(route1)..add(route2);

    expect(underTest.route('get', '/'), equals(Route.notFound()));
    expect(underTest.route('post', '/b'), equals(Route.notFound()));
    expect(underTest.route('put', '/b'), equals(route2));
  });
}
