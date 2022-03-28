import 'package:http/http.dart' as http;
import 'package:map_box_geocoder/map_box_geocoder.dart';

class MapBoxGeocoder {
  final String _accessToken;

  MapBoxGeocoder(this._accessToken);

  /// The forward geocoding query type allows you to look up a single location by name and returns its geographic coordinates.
  Future<MapBoxResponse> forwardSearch(
    String searchText, {
    String endpoint = 'mapbox.places',
    ForwardQueryParams params = const ForwardQueryParams(),
  }) async {
    final uri = _buildUri(endpoint, searchText, params.toMap());
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw response.body;
    }
    return MapBoxResponse.fromJson(response.body);
  }

  /// The reverse geocoding query type allows you to look up a single pair of coordinates and returns the geographic feature or features that exist at that location.
  Future<MapBoxResponse> reverseSearch(
    LatLon coordinates, {
    String endpoint = 'mapbox.places',
    ForwardQueryParams params = const ForwardQueryParams(),
  }) async {
    final uri = _buildUri(endpoint, coordinates.toParamStr(), params.toMap());
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw response.body;
    }
    return MapBoxResponse.fromJson(response.body);
  }

  Uri _buildUri(
      String endpoint, String searchText, Map<String, dynamic> params) {
    return Uri(
      scheme: 'https',
      host: 'api.mapbox.com',
      pathSegments: ['geocoding', 'v5', endpoint, '$searchText.json'],
      queryParameters: {
        'access_token': _accessToken,
        ...params,
      },
    );
  }
}
