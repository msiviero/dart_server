import 'package:dart_server/application.dart';
import 'package:test/test.dart';

void main() {
  test('Route should be tested for equality', () {
    final r1 = Route(
      method: 'GET',
      path: '/a',
      handler: (request) => Response(),
    );

    final r2 = Route(
      method: 'GET',
      path: '/a',
      handler: (request) => Response(),
    );

    expect(r1 == r2, equals(true));
  });

  test('Router should match simple rules', () {
    final route1 = Route(
      method: 'GET',
      path: '/a',
      handler: (request) => Response(),
    );

    final route2 = Route(
      method: 'PUT',
      path: '/b',
      handler: (request) => Response(),
    );

    final underTest = Router()..add(route1)..add(route2);

    expect(underTest.match('get', '/'), equals(null));
    expect(underTest.match('post', '/b'), equals(null));
    expect(underTest.match('put', '/b'), equals(route2));
  });
}
