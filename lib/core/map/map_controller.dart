import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_themes.dart';
import 'country_layer.dart';
import 'geo_parser.dart';
import 'map_layer.dart';
import 'projection.dart';

class MapController extends ChangeNotifier {
  final List<MapLayer> layers = [];
  late CountryLayer _countryLayer;
  MapThemeData _theme = AppThemes.dark;

  MapThemeData get theme => _theme;
  CountryLayer get countryLayer => _countryLayer;

  Future<void> loadGeoData(Map<String, String> countryNames) async {
    final jsonString = await rootBundle.loadString('assets/geo/countries.geojson');
    final projection = Projection();
    final countries = GeoParser.parseGeoJson(jsonString, countryNames);

    _countryLayer = CountryLayer(countries: countries, projection: projection);
    layers.add(_countryLayer);
    notifyListeners();
  }

  void setTheme(MapThemeData theme) {
    _theme = theme;
    notifyListeners();
  }

  void markCorrect(int countryId) {
    _countryLayer.correctIds.add(countryId);
    notifyListeners();
  }

  void markIncorrect(int countryId) {
    _countryLayer.incorrectIds.add(countryId);
    notifyListeners();
  }

  void highlight(int? countryId) {
    _countryLayer.highlightedId = countryId;
    notifyListeners();
  }

  void reset() {
    _countryLayer.correctIds.clear();
    _countryLayer.incorrectIds.clear();
    _countryLayer.highlightedId = null;
    notifyListeners();
  }

  String? getCountryName(int id) {
    final country = _countryLayer.countries.where((c) => c.id == id).firstOrNull;
    return country?.name;
  }
}
