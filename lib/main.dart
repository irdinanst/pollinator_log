import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/glass_card.dart';
import 'widgets/glow_background.dart';

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
      home: const ThemeTestScreen(),
    );
  }
}

// Temporary screen to test the theme and glass widgets.
class ThemeTestScreen extends StatelessWidget {
  const ThemeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('My Pollinator Log', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 24),
                GlassCard(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(68),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Text('Weekly spotting goal',
                      style: theme.textTheme.titleMedium),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}