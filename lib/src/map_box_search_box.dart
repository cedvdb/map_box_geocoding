import 'package:http/http.dart' as http;
import 'package:map_box_geocoder/src/map_box_query_params.dart';
import 'package:map_box_geocoder/src/map_box_response.dart';

/// Client for the [Mapbox Search Box API](https://docs.mapbox.com/api/search/search-box/).
///
/// Supports forward search with POI category filtering, keystroke-by-keystroke
/// autocomplete suggestions, and retrieving full feature data for a selected
/// suggestion via the `/search/searchbox/v1/` endpoints.
///
/// Obtain an instance directly or through [MapBoxGeocoder.searchBox].
class MapBoxSearchBox {
  final String _accessToken;

  MapBoxSearchBox(this._accessToken);

  /// Search for places using the Mapbox Search Box API.
  /// Unlike the legacy Geocoding API, the Search Box API supports filtering by
  /// POI category via [SearchBoxQueryParams.poiCategories].
  Future<MapBoxResponse> forward(
    String searchText, {
    SearchBoxQueryParams params = const SearchBoxQueryParams(),
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.mapbox.com',
      pathSegments: ['search', 'searchbox', 'v1', 'forward'],
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
}
