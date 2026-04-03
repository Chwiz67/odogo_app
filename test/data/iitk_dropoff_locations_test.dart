import 'package:flutter_test/flutter_test.dart';
import 'package:odogo_app/data/iitk_dropoff_locations.dart';

void main() {
  group('IITK Dropoff Locations Data & Logic Tests', () {
    test('Dropoff list is populated securely', () {
      expect(iitkDropoffLocations, isNotEmpty);
      expect(iitkDropoffLocations.length, greaterThan(10));
    });

    group('matches() instance method', () {
      const testLocation = DropoffLocation(
        name: 'Main Gate',
        latitude: 26.5108,
        longitude: 80.2466,
        aliases: <String>['icici', 'parking'],
      );

      test('returns true for an empty or whitespace query', () {
        expect(testLocation.matches(''), isTrue);
        expect(testLocation.matches('   '), isTrue);
      });

      test(
        'returns true when query matches the primary name (case-insensitive)',
        () {
          expect(testLocation.matches('main'), isTrue); // partial
          expect(testLocation.matches('GATE'), isTrue); // partial caps
          expect(testLocation.matches('Main Gate'), isTrue); // exact
        },
      );

      test('returns true when query matches an alias (case-insensitive)', () {
        expect(testLocation.matches('ici'), isTrue); // partial alias
        expect(testLocation.matches('PARKING'), isTrue); // exact alias caps
      });

      test('returns false when there is no match', () {
        expect(testLocation.matches('library'), isFalse);
        expect(testLocation.matches('xyz'), isFalse);
      });
    });

    group('fromName() static method', () {
      test('returns correct DropoffLocation on exact primary name match', () {
        // Includes testing the .trim() and .toLowerCase() sanitization
        final result = DropoffLocation.fromName('  mAin gAte  ');
        expect(result, isNotNull);
        expect(result?.name, 'Main Gate');
      });

      test('returns correct DropoffLocation on exact alias match', () {
        // 'oat' is an alias for Open Air Theatre
        final result = DropoffLocation.fromName('oat');
        expect(result, isNotNull);
        expect(result?.name, 'Open Air Theatre/ New SAC');
      });

      test('returns null if the location is completely unknown', () {
        final result = DropoffLocation.fromName('Hogwarts');
        expect(result, isNull);
      });

      test(
        'returns null if it is only a partial match (fromName requires exact)',
        () {
          final result = DropoffLocation.fromName('Main G');
          expect(result, isNull);
        },
      );
    });
  });
}
