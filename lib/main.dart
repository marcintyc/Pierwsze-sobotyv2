import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'screens/home_screen.dart';
import 'screens/conditions_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/info_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pl_PL';
  runApp(const PierwszeSobotyApp());
}

class PierwszeSobotyApp extends StatelessWidget {
  const PierwszeSobotyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF1E88E5);
    final Color maryWhite = const Color(0xFFFDFDFD);
    final Color gold = const Color(0xFFF9A825);
    final Color softPink = const Color(0xFFFFCDD2);

    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: gold,
      surface: maryWhite,
      tertiary: softPink,
      brightness: Brightness.light,
    );

    final ThemeData theme = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: maryWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: maryWhite,
        foregroundColor: primaryBlue,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontWeight: FontWeight.w600),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primaryBlue;
          return primaryBlue.withOpacity(0.5);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );

    return MaterialApp(
      title: 'Pierwsze Soboty',
      debugShowCheckedModeBanner: false,
      theme: theme,
      routes: {
        '/': (context) => const HomeScreen(),
        ConditionsScreen.routeName: (context) => const ConditionsScreen(),
        ProgressScreen.routeName: (context) => const ProgressScreen(),
        InfoScreen.routeName: (context) => const InfoScreen(),
      },
    );
  }
}