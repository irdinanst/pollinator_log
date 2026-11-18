import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const PollinatorApp());
}

class PollinatorApp extends StatelessWidget {
  const PollinatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pollinator Log',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const OnboardingScreen(),
    );
  }
}