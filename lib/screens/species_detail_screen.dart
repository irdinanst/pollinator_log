import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/species_info.dart';
import '../models/sighting.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';

/// The parent supplies the logging action so sightings stay in HomeShell.
class SpeciesDetailScreen extends StatefulWidget {
  const SpeciesDetailScreen({super.key, this.sighting, required this.onLogSpecies});

  final Sighting? sighting; // which card was tapped (null = Asian honey bee)
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

    // Content for the tapped species
    final s = widget.sighting;
    final info = infoFor(
      group: s?.group ?? 'Bee',
      scientificName: s?.scientificName ?? '',
      species: s?.species ?? '',
    );

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
                    // Honey bee keeps the emoji, other species show their drawing
                    child: Center(
                      child: info.emoji != null
                          ? Text(info.emoji!, style: const TextStyle(fontSize: 72))
                          : SizedBox(
                              height: 140,
                              child: SvgPicture.asset(
                                info.drawing,
                                semanticsLabel: 'Drawing of ${info.name}',
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(info.name,
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
                  Text(info.scientificName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: scheme.primary,
                      )),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final f in info.facts)
                        _Fact(value: f.value, label: f.label),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    info.description,
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
                        for (final part in info.bodyParts)
                          _BodyPart(name: part.name, detail: part.detail),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Plants visited', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final plant in info.plants)
                        Chip(label: Text(plant)),
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