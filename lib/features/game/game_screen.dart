import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/data/country_data.dart';
import '../../core/map/map_controller.dart';
import '../../core/map/map_widget.dart';

class GameScreen extends StatefulWidget {
  final String region;

  const GameScreen({super.key, required this.region});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MapController _mapController = MapController();
  bool _loading = true;

  List<int> _queue = [];
  int _currentIndex = 0;
  int _score = 0;
  int _lives = 3;
  bool _gameOver = false;

  String get _currentCountryName {
    if (_currentIndex >= _queue.length) return '';
    return CountryData.names[_queue[_currentIndex].toString()] ?? '???';
  }

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  Future<void> _initGame() async {
    await _mapController.loadGeoData(CountryData.names);
    _buildQueue();
    setState(() => _loading = false);
  }

  void _buildQueue() {
    List<String> ids;
    if (widget.region == 'world') {
      ids = CountryData.names.keys.toList();
    } else {
      ids = CountryData.continents[widget.region] ?? [];
    }

    _queue = ids.map((s) => int.parse(s)).toList()..shuffle(Random());
    _currentIndex = 0;
    _score = 0;
    _lives = 3;
    _gameOver = false;
  }

  void _onCountryTap(int countryId) {
    if (_gameOver || _currentIndex >= _queue.length) return;

    final targetId = _queue[_currentIndex];

    setState(() {
      if (countryId == targetId) {
        _mapController.markCorrect(countryId);
        _score++;
        _nextCountry();
      } else {
        _mapController.markIncorrect(countryId);
        _lives--;
        if (_lives <= 0) {
          _mapController.markCorrect(targetId);
          _gameOver = true;
        }
      }
    });
  }

  void _nextCountry() {
    _currentIndex++;
    if (_currentIndex >= _queue.length) {
      _gameOver = true;
    }
  }

  void _restart() {
    _mapController.reset();
    setState(() {
      _buildQueue();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: _mapController,
            builder: (context, _) => InteractiveMap(
              layers: _mapController.layers,
              mapTheme: _mapController.theme,
              onCountryTap: _onCountryTap,
            ),
          ),
          _buildHud(),
          if (_gameOver) _buildGameOver(),
        ],
      ),
    );
  }

  Widget _buildHud() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text('$_score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                Text('Score', style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
              ],
            ),
            Expanded(
              child: Text(
                _currentCountryName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Row(
              children: List.generate(3, (i) => Icon(
                Icons.favorite,
                size: 20,
                color: i < _lives ? Colors.redAccent : Colors.grey.withValues(alpha: 0.3),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOver() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Partie terminée', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              Text('Score: $_score / ${_queue.length}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _restart,
                icon: const Icon(Icons.refresh),
                label: const Text('Rejouer'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
