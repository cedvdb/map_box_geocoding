import 'package:map_box_geocoder/src/map_box_geocoding.dart';
import 'package:map_box_geocoder/src/map_box_search_box.dart';

export 'map_box_geocoding.dart';
export 'map_box_search_box.dart';

/// Facade that provides access to both Mapbox API clients.
///
/// Use [geocoding] for the legacy [Mapbox Geocoding API](https://docs.mapbox.com/api/search/geocoding/)
/// (forward and reverse geocoding), and [searchBox] for the
/// [Mapbox Search Box API](https://docs.mapbox.com/api/search/search-box/)
/// (forward search, autocomplete suggestions, and feature retrieval).
///
/// ```dart
/// final client = MapBoxClient('YOUR_MAPBOX_ACCESS_TOKEN');
///
/// // Legacy Geocoding API
/// final result = await client.geocoding.forwardSearch('Paris, France');
///
/// // Search Box API
/// final suggestions = await client.searchBox.suggest(
///   'Eiffel',
///   params: SuggestQueryParams(sessionToken: sessionToken),
/// );
/// ```
class MapBoxClient {
  /// Client for the legacy [Mapbox Geocoding API](https://docs.mapbox.com/api/search/geocoding/).
  ///
  /// Provides [MapBoxGeocoding.forwardSearch] and [MapBoxGeocoding.reverseSearch].
  final MapBoxGeocoding geocoding;

  /// Client for the [Mapbox Search Box API](https://docs.mapbox.com/api/search/search-box/).
  ///
  /// Provides [MapBoxSearchBox.forward], [MapBoxSearchBox.suggest], and
  /// [MapBoxSearchBox.retrieve].
  final MapBoxSearchBox searchBox;

  MapBoxClient(String accessToken)
      : geocoding = MapBoxGeocoding(accessToken),
        searchBox = MapBoxSearchBox(accessToken);
}
