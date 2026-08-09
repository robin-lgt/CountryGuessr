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
  bool _initialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initZoom(double viewW, double viewH, double mapW, double mapH) {
    if (_initialized) return;
    _initialized = true;

    // Zoom so the map height fills the viewport height
    final scale = viewH / mapH;
    // Center horizontally
    final dx = -(mapW * scale - viewW) / 2;
    _controller.value = Matrix4.identity()
      ..translateByDouble(dx, 0.0, 0.0, 1.0)
      ..scaleByDouble(scale, scale, 1.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewW = constraints.maxWidth;
        final viewH = constraints.maxHeight;
        final mapH = viewW * Projection.aspectRatio;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _initZoom(viewW, viewH, viewW, mapH);
        });

        return Container(
          color: widget.mapTheme.waterColor,
          width: viewW,
          height: viewH,
          child: InteractiveViewer(
            transformationController: _controller,
            minScale: 0.5,
            maxScale: 80.0,
            boundaryMargin: EdgeInsets.zero,
            constrained: false,
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
                    size: Size(viewW, mapH),
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
