import 'package:map_box_geocoder/map_box_geocoder.dart';
import 'package:test/test.dart';

// give map box token to run test with dart test/geocoder_test.dart MAP_BOX_TOKEN

final streetCoords = LatLon(
  48.822571,
  2.353356,
);
final street = '7 Rue du Dr. Lecène, Paris, France';

void main() {
  final accessToken = const String.fromEnvironment('MAP_BOX_TOKEN');
  late MapBoxGeocoder geocoder;

  setUp(() {
    geocoder = MapBoxGeocoder(accessToken);
  });

  group('forward geocoding', () {
    test('Should find exact coordinates of address', () async {
      final result = await geocoder.forwardSearch(street);
      final parisStreet = result.features.first;
      expect(parisStreet.center.latitude, equals(streetCoords.latitude));
      expect(parisStreet.center.longitude, equals(streetCoords.longitude));
    });
    test('Should give predictions', () async {
      final result = await geocoder.forwardSearch(
        'Pa',
        params: ForwardQueryParams(
          proximity: LatLon(48.8566, 2.3522),
          language: 'en',
          types: [PlaceType.place],
          fuzzyMatch: true,
          autocomplete: true,
          limit: 1,
        ),
      );
      final found = result.features
          .firstWhere((prediction) => prediction.text.contains('Paris'));
      expect(found, isA<Feature>());
    });
  });

  group('reverse geocoding', () {
    test('should give address', () async {
      final result = await geocoder.reverseSearch(
        streetCoords,
        params: ReverseQueryParams(
          language: 'en',
          limit: 1,
        ),
      );
      expect(result.features.first.text.contains('Lecène'), isTrue);
    });
  });

  group('search box forward', () {
    test('Should find POIs by name', () async {
      final result = await geocoder.searchBoxForward(
        'coffee',
        params: SearchBoxQueryParams(
          proximity: LatLon(48.8566, 2.3522),
          language: 'en',
          limit: 5,
        ),
      );
      expect(result.features, isNotEmpty);
    });

    test('Should filter POIs by category', () async {
      final result = await geocoder.searchBoxForward(
        'coffee',
        params: SearchBoxQueryParams(
          proximity: LatLon(48.8566, 2.3522),
          language: 'en',
          limit: 5,
          poiCategories: ['coffee_shop'],
        ),
      );
      expect(result.features, isNotEmpty);
    });
  });

  group('search box suggest & retrieve', () {
    const sessionToken = 'test-session-uuid-1234';

    test('Should return suggestions for a query', () async {
      final result = await geocoder.suggest(
        'Starbucks',
        params: SuggestQueryParams(
          proximity: LatLon(48.8566, 2.3522),
          language: 'en',
          limit: 5,
          sessionToken: sessionToken,
        ),
      );
      expect(result.suggestions, isNotEmpty);
      final first = result.suggestions.first;
      expect(first.mapboxId, isNotEmpty);
      expect(first.name, isNotEmpty);
    });

    test('Should retrieve full feature for a suggestion', () async {
      final suggestResult = await geocoder.suggest(
        'Starbucks',
        params: SuggestQueryParams(
          proximity: LatLon(48.8566, 2.3522),
          language: 'en',
          limit: 1,
          sessionToken: sessionToken,
        ),
      );
      expect(suggestResult.suggestions, isNotEmpty);
      final mapboxId = suggestResult.suggestions.first.mapboxId;

      final retrieveResult = await geocoder.retrieve(
        mapboxId,
        sessionToken: sessionToken,
      );
      expect(retrieveResult.features, isNotEmpty);
      final feature = retrieveResult.features.first;
      expect(feature.center.latitude, isNonZero);
      expect(feature.center.longitude, isNonZero);
    });

    test('Should pass session token in suggest and retrieve', () async {
      final suggestResult = await geocoder.suggest(
        'coffee',
        params: SuggestQueryParams(
          proximity: LatLon(48.8566, 2.3522),
          language: 'en',
          limit: 3,
          sessionToken: sessionToken,
        ),
      );
      expect(suggestResult.suggestions, isNotEmpty);

      final mapboxId = suggestResult.suggestions.first.mapboxId;
      final retrieveResult = await geocoder.retrieve(
        mapboxId,
        sessionToken: sessionToken,
      );
      expect(retrieveResult.features, isNotEmpty);
    });
  });
}
