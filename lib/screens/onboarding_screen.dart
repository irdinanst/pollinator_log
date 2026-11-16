import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  // Each item supplies the content for one introduction page.
  static const _pages = [
    (
      title: 'Spot',
      description: 'See a bee, butterfly or sunbird on a flower? '
          'Note what it was, where, and which plant it visited.',
      icon: Icons.local_florist_outlined,
    ),
    (
      title: 'Record',
      description: 'Keep your sightings in one place. Add the species, '
          'plant visited, location and number you saw.',
      icon: Icons.edit_note_rounded,
    ),
    (
      title: 'Explore',
      description: 'Learn about pollinator species and revisit your '
          'sightings as you discover more around you.',
      icon: Icons.explore_outlined,
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _openLogin();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextButton(
                        onPressed: _openLogin,
                        child: const Text('Skip'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            // Scrolling prevents overflow on short screens.
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(24),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: (constraints.maxHeight - 48)
                                      .clamp(0.0, double.infinity)
                                      .toDouble(),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GlassCard(
                                      padding: const EdgeInsets.all(36),
                                      child: Icon(
                                        page.icon,
                                        size: 100,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    Text(
                                      page.title,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headlineLarge
                                          ?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      page.description,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(height: 1.5),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                    child: Column(
                      children: [
                        Semantics(
                          label: 'Introduction page ${_currentPage + 1} '
                              'of ${_pages.length}',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_pages.length, (index) {
                              final selected = index == _currentPage;
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: selected ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.primary
                                          .withValues(alpha: 0.20),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _nextPage,
                          child: Text(lastPage ? 'Get Started' : 'Next'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
