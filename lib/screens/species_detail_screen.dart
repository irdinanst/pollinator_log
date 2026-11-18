import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';

/// The parent supplies the logging action so sightings stay in HomeShell.
class SpeciesDetailScreen extends StatefulWidget {
  const SpeciesDetailScreen({super.key, required this.onLogSpecies});

  final VoidCallback onLogSpecies;

  @override
  State<SpeciesDetailScreen> createState() => _SpeciesDetailScreenState();
}

class _SpeciesDetailScreenState extends State<SpeciesDetailScreen> {
  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Species Detail')),
      body: GlowBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                children: [
                  // Decorative illustration; no external image download needed.
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          scheme.secondary.withValues(alpha: 0.45),
                          scheme.secondary.withValues(alpha: 0.12),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text('🐝 🌻', style: TextStyle(fontSize: 72)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text('Asian honey bee',
                            style: theme.textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      IconButton.filledTonal(
                        tooltip: _isFavourite
                            ? 'Remove from favourites'
                            : 'Add to favourites',
                        onPressed: () {
                          setState(() => _isFavourite = !_isFavourite);
                        },
                        icon: Icon(_isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border),
                      ),
                    ],
                  ),
                  Text('Apis cerana',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: scheme.primary,
                      )),
                  const SizedBox(height: 20),
                  const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _Fact(value: '~10 mm', label: 'Size'),
                      _Fact(value: 'Daytime', label: 'Active'),
                      _Fact(value: 'Hollows', label: 'Nests in'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'A native honey bee that lives in colonies in tree hollows '
                    'and wall gaps. It visits fruit trees, wildflowers and '
                    'garden plants, carrying pollen home in baskets on its '
                    'back legs.',
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Body structure',
                            style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        const _BodyPart(name: 'Wings', detail: 'Used for flight.'),
                        const _BodyPart(name: 'Antennae', detail: 'Sense the surroundings.'),
                        const _BodyPart(name: 'Striped abdomen', detail: 'The rear section of the body.'),
                        const _BodyPart(name: 'Compound eyes', detail: 'Help detect movement and shapes.'),
                        const _BodyPart(name: 'Pollen baskets', detail: 'Carry pollen on the hind legs.'),
                        const _BodyPart(name: 'Stinger', detail: 'Used by workers for defence.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Plants visited', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      Chip(label: Text('Sunflower')),
                      Chip(label: Text('Asystasia')),
                      Chip(label: Text('Coconut')),
                      Chip(label: Text('Rambutan')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: widget.onLogSpecies,
                    icon: const Icon(Icons.add),
                    label: const Text('Log this species'),
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

class _Fact extends StatelessWidget {
  const _Fact({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        children: [
          Text(value, style: theme.textTheme.titleSmall
              ?.copyWith(color: theme.colorScheme.primary)),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _BodyPart extends StatelessWidget {
  const _BodyPart({required this.name, required this.detail});
  final String name;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: '$name: ',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        TextSpan(text: detail),
      ]), style: theme.textTheme.bodyMedium),
    );
  }
}
