import 'package:map_box_geocoder/map_box_geocoder.dart';
import 'package:test/test.dart';

final streetCoords = LatLon(
  48.822571,
  2.353356,
);
final street = '7 Rue du Dr. Lecène, Paris, France';
void main(List<String> args) {
  final accessToken = args[0];
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
          types: [Types.place],
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
}
