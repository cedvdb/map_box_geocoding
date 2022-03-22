import 'package:map_box_geocoder/map_box_geocoder.dart';
import 'package:map_box_geocoder/src/map_box_response.dart';

import 'package:http/http.dart' as http;

import 'map_box_query_params.dart';

class MapBoxGeocoder {
  final String _accessToken;

  MapBoxGeocoder(this._accessToken);

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
