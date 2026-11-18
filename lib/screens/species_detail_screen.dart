import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../data/species_info.dart';
import '../models/sighting.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';

/// Shows facts about the tapped sighting's species.
/// The parent supplies the logging action so sightings stay in HomeShell.
class SpeciesDetailScreen extends StatefulWidget {
  const SpeciesDetailScreen({
    super.key,
    this.sighting,
    required this.onLogSpecies,
  });

  final Sighting? sighting; // null = default (Asian honey bee)
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

    final s = widget.sighting;
    final info = infoFor(
      group: s?.group ?? 'Bee',
      scientificName: s?.scientificName ?? '',
      species: s?.species ?? '',
    );
    // Use the names the user typed, fall back to the guide's names.
    final name = (s == null || s.species.isEmpty) ? info.name : s.species;
    final latin = (s == null || s.scientificName.isEmpty)
        ? info.scientificName
        : s.scientificName;

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
                  // Gradient box with the species drawing and a flower
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
                    // Honey bee keeps Norman's original emoji art,
                    // the other species show their drawings.
                    child: info.emoji != null
                        ? Center(
                            child: Text(
                              info.emoji!,
                              style: const TextStyle(fontSize: 72),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -16,
                                  bottom: -24,
                                  width: 180,
                                  height: 180,
                                  child: SvgPicture.asset(info.flower),
                                ),
                                Positioned(
                                  left: 12,
                                  top: 24,
                                  width: 210,
                                  child: SvgPicture.asset(
                                    info.drawing,
                                    semanticsLabel: 'Drawing of $name',
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: _isFavourite
                            ? 'Remove from favourites'
                            : 'Add to favourites',
                        onPressed: () {
                          setState(() => _isFavourite = !_isFavourite);
                        },
                        icon: Icon(
                          _isFavourite ? Icons.favorite : Icons.favorite_border,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    latin,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: scheme.primary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      for (int i = 0; i < info.facts.length; i++) ...[
                        if (i > 0) const SizedBox(width: 10),
                        Expanded(
                          child: _Fact(
                            value: info.facts[i].value,
                            label: info.facts[i].label,
                          ),
                        ),
                      ],
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
                        Text(
                          'Body structure',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        // Labelled diagram when we have one (bees for now)
                        if (info.diagram != null) ...[
                          AspectRatio(
                            aspectRatio: 340 / 220,
                            child: SvgPicture.asset(
                              info.diagram!,
                              semanticsLabel: 'Labelled diagram of body parts',
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
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
                      for (final plant in info.plants) Chip(label: Text(plant)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: widget.onLogSpecies,
                      icon: const Icon(Icons.add),
                      label: const Text('Log this species'),
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

class _Fact extends StatelessWidget {
  const _Fact({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
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
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$name: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: detail),
          ],
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}
