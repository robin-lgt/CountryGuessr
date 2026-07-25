import 'package:flutter/material.dart';
import '../theme/app_themes.dart';
import 'geo_parser.dart';
import 'map_layer.dart';
import 'projection.dart';

class CountryLayer extends MapLayer {
  final List<GeoCountry> countries;
  final Projection projection;
  final Set<int> correctIds = {};
  final Set<int> incorrectIds = {};
  int? highlightedId;

  static const double _markerRadius = 5.0;
  static const double _markerHitRadius = 12.0;
  static const double _smallCountryThreshold = 50.0;

  CountryLayer({required this.countries, required this.projection})
      : super(id: 'countries');

  @override
  void paint(Canvas canvas, Size size, Matrix4 transform, MapThemeData theme) {
    for (final country in countries) {
      final color = _colorForCountry(country.id, theme);
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final borderPaint = Paint()
        ..color = theme.countryBorder
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.3;

      for (final polygon in country.polygons) {
        if (polygon.length < 3) continue;
        final path = _buildPath(polygon, size);
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, borderPaint);
      }
    }

    // Draw markers for small countries
    for (final country in countries) {
      if (_isSmallCountry(country, size)) {
        final center = projection.project(country.centroid, size);
        final color = _colorForCountry(country.id, theme);
        final markerPaint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        final borderPaint = Paint()
          ..color = theme.countryBorder
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawCircle(center, _markerRadius, markerPaint);
        canvas.drawCircle(center, _markerRadius, borderPaint);
      }
    }
  }

  bool _isSmallCountry(GeoCountry country, Size size) {
    final bounds = _getBounds(country, size);
    final area = bounds.width * bounds.height;
    return area < _smallCountryThreshold;
  }

  Rect _getBounds(GeoCountry country, Size size) {
    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

    for (final polygon in country.polygons) {
      for (final point in polygon) {
        final projected = projection.project(point, size);
        if (projected.dx < minX) minX = projected.dx;
        if (projected.dx > maxX) maxX = projected.dx;
        if (projected.dy < minY) minY = projected.dy;
        if (projected.dy > maxY) maxY = projected.dy;
      }
    }

    return Rect.fromLTRB(minX, minY, maxX, maxY);
  }

  Color _colorForCountry(int id, MapThemeData theme) {
    if (correctIds.contains(id)) return theme.correctFill;
    if (incorrectIds.contains(id)) return theme.incorrectFill;
    if (highlightedId == id) return theme.highlightFill;
    return theme.countryFill;
  }

  Path _buildPath(List<Offset> polygon, Size size) {
    final path = Path();
    bool first = true;
    for (final point in polygon) {
      final projected = projection.project(point, size);
      if (first) {
        path.moveTo(projected.dx, projected.dy);
        first = false;
      } else {
        path.lineTo(projected.dx, projected.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  int? hitTest(Offset localPosition, Matrix4 transform) {
    final inverseTransform = Matrix4.tryInvert(transform);
    if (inverseTransform == null) return null;

    final point = MatrixUtils.transformPoint(inverseTransform, localPosition);

    // Use a fixed size for hit-testing based on the widget's logical size
    // We'll use a reasonable default that matches what was painted
    final size = _lastPaintedSize ?? const Size(800, 600);

    // Check markers first (small countries) — more generous hit area
    for (final country in countries) {
      if (_isSmallCountry(country, size)) {
        final center = projection.project(country.centroid, size);
        final distance = (point - center).distance;
        if (distance <= _markerHitRadius) {
          return country.id;
        }
      }
    }

    // Check polygon paths
    for (final country in countries) {
      for (final polygon in country.polygons) {
        if (polygon.length < 3) continue;
        final path = _buildPath(polygon, size);
        if (path.contains(point)) {
          return country.id;
        }
      }
    }
    return null;
  }

  Size? _lastPaintedSize;

  void updatePaintedSize(Size size) {
    _lastPaintedSize = size;
  }
}
