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
  double currentScale = 1.0;

  static const double _smallCountryThreshold = 15.0;
  static const _noMarkerIds = {144, 222, 84};

  Size? _cachedSize;
  final Map<int, List<Path>> _pathCache = {};
  final Map<int, Offset> _centroidCache = {};
  final Map<int, double> _areaCache = {};

  CountryLayer({required this.countries, required this.projection})
      : super(id: 'countries');

  void _rebuildCache(Size size) {
    if (_cachedSize == size) return;
    _cachedSize = size;
    _pathCache.clear();
    _centroidCache.clear();
    _areaCache.clear();

    for (final country in countries) {
      final paths = <Path>[];
      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;

      for (final polygon in country.polygons) {
        if (polygon.length < 3) continue;
        final path = Path();
        bool first = true;
        for (final point in polygon) {
          final p = projection.project(point, size);
          if (p.dx < minX) minX = p.dx;
          if (p.dx > maxX) maxX = p.dx;
          if (p.dy < minY) minY = p.dy;
          if (p.dy > maxY) maxY = p.dy;
          if (first) {
            path.moveTo(p.dx, p.dy);
            first = false;
          } else {
            path.lineTo(p.dx, p.dy);
          }
        }
        path.close();
        paths.add(path);
      }
      _pathCache[country.id] = paths;
      _centroidCache[country.id] = projection.project(country.centroid, size);
      _areaCache[country.id] = (maxX - minX) * (maxY - minY);
    }
  }

  bool _needsMarker(int id) {
    if (_noMarkerIds.contains(id)) return false;
    return (_areaCache[id] ?? 0) < _smallCountryThreshold;
  }

  @override
  void paint(Canvas canvas, Size size, Matrix4 transform, MapThemeData theme) {
    _rebuildCache(size);

    final borderPaint = Paint()
      ..color = theme.countryBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3;

    for (final country in countries) {
      final fillPaint = Paint()
        ..color = _colorForCountry(country.id, theme)
        ..style = PaintingStyle.fill;
      final paths = _pathCache[country.id];
      if (paths == null) continue;
      for (final path in paths) {
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, borderPaint);
      }
    }

    // Markers for small countries — radius shrinks with zoom
    final r = (5.0 / currentScale).clamp(1.5, 5.0);
    final mBorder = Paint()
      ..color = theme.countryBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = (1.2 / currentScale).clamp(0.3, 1.2);

    for (final country in countries) {
      if (!_needsMarker(country.id)) continue;
      final c = _centroidCache[country.id];
      if (c == null) continue;
      canvas.drawCircle(c, r, Paint()..color = _colorForCountry(country.id, theme));
      canvas.drawCircle(c, r, mBorder);
    }
  }

  Color _colorForCountry(int id, MapThemeData theme) {
    if (correctIds.contains(id)) return theme.correctFill;
    if (incorrectIds.contains(id)) return theme.incorrectFill;
    if (highlightedId == id) return theme.highlightFill;
    return theme.countryFill;
  }

  @override
  int? hitTest(Offset localPosition, Matrix4 transform) {
    final inv = Matrix4.tryInvert(transform);
    if (inv == null) return null;
    final point = MatrixUtils.transformPoint(inv, localPosition);
    final size = _lastPaintedSize ?? const Size(800, 600);
    _rebuildCache(size);

    final hitR = 14.0 / transform.getMaxScaleOnAxis();

    for (final country in countries) {
      if (!_needsMarker(country.id)) continue;
      final c = _centroidCache[country.id];
      if (c == null) continue;
      if ((point - c).distance <= hitR) return country.id;
    }

    for (final country in countries) {
      final paths = _pathCache[country.id];
      if (paths == null) continue;
      for (final path in paths) {
        if (path.contains(point)) return country.id;
      }
    }
    return null;
  }

  Size? _lastPaintedSize;
  void updatePaintedSize(Size size) => _lastPaintedSize = size;
}
