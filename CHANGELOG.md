## 2.1.0

- add `PropertiesContext` model for Search Box `feature.properties.context`
- add `PropertiesContextEntry` model for individual context entries (`country`, `postcode`, `place`, `region`, `locality`, `neighborhood`, `address`, `street`)
- add `context` field to `Properties`, populated from Search Box `/retrieve` and `/forward` responses

## 2.0.0

**Breaking changes**

- `MapBoxGeocoder` renamed to `MapBoxClient` (facade entry point)
- Split into two focused API clients that mirror Mapbox's own API structure:
  - `MapBoxGeocoding` — wraps the legacy [Geocoding API](https://docs.mapbox.com/api/search/geocoding/) (`forwardSearch`, `reverseSearch`)
  - `MapBoxSearchBox` — wraps the [Search Box API](https://docs.mapbox.com/api/search/search-box/) (`forward`, `suggest`, `retrieve`)
- `MapBoxClient` is a facade with `geocoding` (`MapBoxGeocoding`) and `searchBox` (`MapBoxSearchBox`) properties instead of exposing methods directly
- `searchBoxForward` renamed to `forward` on `MapBoxSearchBox`

**Migration guide**

```dart
// Before (1.x)
final geocoder = MapBoxGeocoder(token);
geocoder.forwardSearch('Paris');
geocoder.reverseSearch(coords);
geocoder.searchBoxForward('coffee');
geocoder.suggest('Eiffel', params: SuggestQueryParams(sessionToken: token));
geocoder.retrieve(id, sessionToken: token);

// After (2.0)
final client = MapBoxClient(token);
client.geocoding.forwardSearch('Paris');
client.geocoding.reverseSearch(coords);
client.searchBox.forward('coffee');
client.searchBox.suggest('Eiffel', params: SuggestQueryParams(sessionToken: token));
client.searchBox.retrieve(id, sessionToken: token);

// Or use the focused clients directly:
final geocoding = MapBoxGeocoding(token);
final searchBox = MapBoxSearchBox(token);
```

- add `suggest` method targeting the Search Box `/suggest` endpoint for keystroke-by-keystroke autocomplete
- add `retrieve` method targeting the Search Box `/retrieve/{mapbox_id}` endpoint to fetch full feature data
- add `MapBoxSuggestion` model for lightweight suggestion items returned by `/suggest`
- add `SuggestResponse` model wrapping the list of suggestions with attribution and response UUID
- add `SuggestQueryParams` with support for `language`, `country`, `limit`, `proximity`, `types`, `poiCategories`, and `sessionToken` for Mapbox session-based billing

## 1.1.0

- add `searchBoxForward` method targeting the Mapbox Search Box API (`/search/searchbox/v1/forward`)
- add `SearchBoxQueryParams` with support for `language`, `country`, `limit`, `proximity`, `types`, and `poiCategories`
- fix response parsing to handle Search Box API feature format (no `place_type`, `center`, `text`, or `place_name` at root level)

## 1.0.0
- upgrade dependencies

## 0.1.1

- relax dependency upgrade

## 0.1.0

- upgrade http dependency

## 0.0.12

- update readme

## 0.0.11

- fix place name which wasn't correctly parsed

## 0.0.10

- hotfix for region
- made placeType a list of PlaceType

## 0.0.9

- added region to types

## 0.0.8

- fix place type which wasn't correctly parsed

## 0.0.7

- fix casting issue

## 0.0.6

- fix error where uri params were not stringified

## 0.0.5

- use correct params for reverse

## 0.0.4+1

- documentation

## 0.0.4

- fix country short_code missing

## 0.0.3

- export response

## 0.0.2

- throw on invalid status code

## 0.0.1

- Initial version.
