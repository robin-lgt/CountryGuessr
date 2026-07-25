import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_themes.dart';
import 'features/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  runApp(const CountryGuessrApp());
}

class CountryGuessrApp extends StatelessWidget {
  const CountryGuessrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CountryGuessr',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.materialLight(),
      darkTheme: AppThemes.materialDark(),
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
