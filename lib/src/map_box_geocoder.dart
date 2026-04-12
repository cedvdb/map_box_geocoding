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
    ReverseQueryParams params = const ReverseQueryParams(),
  }) async {
    final uri = _buildUri(endpoint, coordinates.toParamStr(), params.toMap());
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw response.body;
    }
    return MapBoxResponse.fromJson(response.body);
  }

  /// Search for places using the Mapbox Search Box API.
  /// Unlike the legacy Geocoding API, the Search Box API supports filtering by
  /// POI category via [SearchBoxQueryParams.poiCategories].
  Future<MapBoxResponse> searchBoxForward(
    String searchText, {
    SearchBoxQueryParams params = const SearchBoxQueryParams(),
  }) async {
    final uri = _buildSearchBoxUri(searchText, params.toMap());
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw response.body;
    }
    return MapBoxResponse.fromJson(response.body);
  }

  /// Returns lightweight autocomplete suggestions for [searchText] using the
  /// Search Box `/suggest` endpoint.
  ///
  /// The suggestions do **not** contain full geometry. Call [retrieve] with the
  /// [MapBoxSuggestion.mapboxId] from a chosen suggestion to obtain complete
  /// geographic data.
  ///
  /// Pass a stable [SuggestQueryParams.sessionToken] (random UUID) to group
  /// this call with the subsequent [retrieve] call into a single billable
  /// Mapbox session.
  Future<SuggestResponse> suggest(
    String searchText, {
    required SuggestQueryParams params,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.mapbox.com',
      pathSegments: ['search', 'searchbox', 'v1', 'suggest'],
      queryParameters: {
        'q': searchText,
        'access_token': _accessToken,
        ...params.toMap(),
      },
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw response.body;
    }
    return SuggestResponse.fromJson(response.body);
  }

  /// Retrieves the full geographic feature for a suggestion identified by
  /// [mapboxId].
  ///
  /// Pass the same [sessionToken] that was used in the [suggest] call so that
  /// Mapbox can bill the pair as a single session.
  Future<MapBoxResponse> retrieve(
    String mapboxId, {
    required String sessionToken,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.mapbox.com',
      pathSegments: ['search', 'searchbox', 'v1', 'retrieve', mapboxId],
      queryParameters: {
        'access_token': _accessToken,
        'session_token': sessionToken,
      },
    );
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

  Uri _buildSearchBoxUri(
      String searchText, Map<String, dynamic> params) {
    return Uri(
      scheme: 'https',
      host: 'api.mapbox.com',
      pathSegments: ['search', 'searchbox', 'v1', 'forward'],
      queryParameters: {
        'q': searchText,
        'access_token': _accessToken,
        ...params,
      },
    );
  }
}
