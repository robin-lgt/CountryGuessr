import 'package:flutter/material.dart';
import '../game/game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              Text(
                'CountryGuessr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Trouve les pays sur la carte',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(flex: 3),
              _ModeButton(
                label: 'Monde',
                icon: Icons.public,
                onTap: () => _startGame(context, 'world'),
              ),
              const SizedBox(height: 12),
              _ModeButton(
                label: 'Europe',
                icon: Icons.flag,
                onTap: () => _startGame(context, 'europe'),
              ),
              const SizedBox(height: 12),
              _ModeButton(
                label: 'Afrique',
                icon: Icons.terrain,
                onTap: () => _startGame(context, 'africa'),
              ),
              const SizedBox(height: 12),
              _ModeButton(
                label: 'Asie',
                icon: Icons.temple_buddhist,
                onTap: () => _startGame(context, 'asia'),
              ),
              const SizedBox(height: 12),
              _ModeButton(
                label: 'Amériques',
                icon: Icons.landscape,
                onTap: () => _startGame(context, 'americas'),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }

  void _startGame(BuildContext context, String region) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GameScreen(region: region),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Icon(icon, color: colorScheme.primary),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.4)),
            ],
          ),
        ),
      ),
    );
  }
}
