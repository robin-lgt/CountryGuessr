import 'package:flutter/material.dart';
import '../theme/app_themes.dart';
import 'country_layer.dart';
import 'map_layer.dart';
import 'projection.dart';

class InteractiveMap extends StatefulWidget {
  final List<MapLayer> layers;
  final MapThemeData mapTheme;
  final void Function(int countryId)? onCountryTap;

  const InteractiveMap({
    super.key,
    required this.layers,
    required this.mapTheme,
    this.onCountryTap,
  });

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  final TransformationController _controller = TransformationController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final mapH = w * Projection.aspectRatio;

        return Container(
          color: widget.mapTheme.waterColor,
          width: w,
          height: h,
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 1.0,
            maxScale: 80.0,
            boundaryMargin: EdgeInsets.zero,
            child: GestureDetector(
              onTapUp: _onTapUp,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final scale = _controller.value.getMaxScaleOnAxis();
                  return CustomPaint(
                    painter: _MapPainter(
                      layers: widget.layers,
                      theme: widget.mapTheme,
                      viewScale: scale,
                    ),
                    size: Size(w, mapH),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _onTapUp(TapUpDetails details) {
    final transform = _controller.value;
    for (final layer in widget.layers) {
      if (!layer.visible) continue;
      final id = layer.hitTest(details.localPosition, transform);
      if (id != null) {
        widget.onCountryTap?.call(id);
        return;
      }
    }
  }
}

class _MapPainter extends CustomPainter {
  final List<MapLayer> layers;
  final MapThemeData theme;
  final double viewScale;

  _MapPainter({
    required this.layers,
    required this.theme,
    required this.viewScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = theme.waterColor);

    final identity = Matrix4.identity();
    for (final layer in layers) {
      if (layer.visible) {
        if (layer is CountryLayer) {
          layer.updatePaintedSize(size);
          layer.currentScale = viewScale;
        }
        layer.paint(canvas, size, identity, theme);
      }
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) =>
      old.viewScale != viewScale || old.theme != theme;
}
