import 'package:flutter/material.dart';
import 'theme/app_theme.dart';

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
      theme: AppTheme.light(), // the ONE ThemeData for the whole app
      home: const ThemeTestScreen(),
    );
  }
}

// Temporary screen to check the theme works. We'll replace it later.
class ThemeTestScreen extends StatelessWidget {
  const ThemeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // how every screen reads the theme

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('My Pollinator Log', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text('Theme test', style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
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
    );
  }
}