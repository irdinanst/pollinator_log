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
    required this.onRestore,
    required this.filter,
    required this.onFilterChanged,
  });

  final List<Sighting> sightings;
  final VoidCallback onAdd;
  final void Function(Sighting) onEdit;
  final void Function(Sighting) onDelete;
  final void Function(Sighting, int) onRestore;
  final String filter;                       // selected group, e.g. 'Bee'
  final ValueChanged<String> onFilterChanged; // "please change the filter"

  static const double tabletBreakpoint = 600;

  // Group value -> label shown on the chip
  static const Map<String, String> filterLabels = {
    'All': 'All',
    'Bee': 'Bees',
    'Butterfly': 'Butterflies',
    'Bird': 'Birds',
    'Fly': 'Flies',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Only the sightings that match the chosen filter
    final visible = filter == 'All'
        ? sightings
        : sightings.where((s) => s.group == filter).toList();

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
                  '${visible.length} of ${sightings.length} sightings · swipe left to delete',
                  style: theme.textTheme.bodyMedium,
                ),
              ),

              // ── Filter chips (scroll sideways on small phones) ──
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: filterLabels.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(entry.value),
                        selected: filter == entry.key,
                        onSelected: (_) => onFilterChanged(entry.key),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: Text(
                          filter == 'All'
                              ? 'No sightings yet. Tap + to add one.'
                              : 'No ${filterLabels[filter]!.toLowerCase()} logged yet.',
                          style: theme.textTheme.bodyLarge,
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth >= tabletBreakpoint;

                          if (isWide) {
                            return GridView.builder(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                              itemCount: visible.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                mainAxisExtent: 270,
                              ),
                              itemBuilder: (context, index) =>
                                  _buildItem(context, visible[index]),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                            itemCount: visible.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildItem(context, visible[index]),
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

  Widget _buildItem(BuildContext context, Sighting sighting) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(sighting.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(Icons.delete_outline, color: theme.colorScheme.onError),
      ),
      confirmDismiss: (_) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Delete sighting?'),
            content: Text('Remove ${sighting.species} from your log?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        return confirmed ?? false;
      },
      onDismissed: (_) {
        // Remember its position in the FULL list (not the filtered one)
        final originalIndex = sightings.indexOf(sighting);
        onDelete(sighting);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('${sighting.species} deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () => onRestore(sighting, originalIndex),
              ),
            ),
          );
      },
      child: _SightingCard(
        sighting: sighting,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SpeciesDetailScreen(
              sighting: sighting,
              onLogSpecies: () {
                Navigator.pop(context);
                onAdd();
              },
            ),
          ),
        ),
        onEdit: () => onEdit(sighting),
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text(sighting.scientificName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontStyle: FontStyle.italic)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.local_florist_outlined, size: 16, color: scheme.primary),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(sighting.plant,
                                  style: theme.textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis),
                            ),
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
                        Text(_formatDate(sighting.dateTime),
                            style: theme.textTheme.bodySmall),
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