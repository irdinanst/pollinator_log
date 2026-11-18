import 'package:flutter/material.dart';
import '../models/sighting.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';
import 'species_detail_screen.dart';

class SightingsLogScreen extends StatelessWidget {
  const SightingsLogScreen({
    super.key,
    required this.sightings,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Sighting> sightings;
  final VoidCallback onAdd;
  final void Function(Sighting) onEdit;
  final void Function(Sighting) onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
                child: Text('Sightings',
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Text(
                  '${sightings.length} sightings · swipe left to delete',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: sightings.isEmpty
                    ? Center(
                        child: Text('No sightings yet. Tap + to add one.',
                            style: theme.textTheme.bodyLarge))
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                        itemCount: sightings.length,
                        itemBuilder: (context, index) {
                          final sighting = sightings[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Dismissible(
                              key: ValueKey(sighting.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 24),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(Icons.delete_outline,
                                    color: theme.colorScheme.onError),
                              ),
                              onDismissed: (_) {
                                onDelete(sighting);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${sighting.species} deleted')),
                                );
                              },
                              child: _SightingCard(
                                sighting: sighting,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SpeciesDetailScreen(
                                      onLogSpecies: () {
                                        Navigator.pop(context);
                                        onAdd();
                                      },
                                    ),
                                  ),
                                ),
                                onEdit: () => onEdit(sighting),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SightingCard extends StatelessWidget {
  const _SightingCard({
    required this.sighting,
    required this.onTap,
    required this.onEdit,
  });

  final Sighting sighting;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  Color _groupColor(ColorScheme scheme) {
    switch (sighting.group) {
      case 'Bee':
        return scheme.secondary;
      case 'Butterfly':
      case 'Moth':
        return scheme.tertiary;
      default:
        return scheme.primary;
    }
  }

  String _formatDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final hh = d.hour.toString().padLeft(2, '0');
    final mm = d.minute.toString().padLeft(2, '0');
    return '${d.day} ${months[d.month - 1]}, $hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final groupColor = _groupColor(scheme);

    return GlassCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(color: groupColor.withValues(alpha: 0.18)),
              child: Stack(
                children: [
                  Center(child: Icon(Icons.emoji_nature, size: 64, color: groupColor)),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        sighting.verified ? 'Verified' : 'Needs ID',
                        style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: IconButton(
                      onPressed: onEdit,
                      tooltip: 'Edit sighting',
                      icon: Icon(Icons.edit_outlined, color: scheme.primary),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(sighting.species,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text(sighting.scientificName,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.local_florist_outlined, size: 16, color: scheme.primary),
                            const SizedBox(width: 4),
                            Text(sighting.plant, style: theme.textTheme.bodySmall),
                            const SizedBox(width: 12),
                            Icon(Icons.place_outlined, size: 16, color: scheme.primary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(sighting.location,
                                  style: theme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(_formatDate(sighting.dateTime), style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text('×${sighting.count}',
                          style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700, color: scheme.primary)),
                      Text('seen', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}