import 'package:flutter/material.dart';
import '../models/sighting.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.sightings});

  final List<Sighting> sightings;

  static const int spottingGoal = 10; // target number of sightings

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            children: [
              // ── Header ──
              Row(
                children: [
                  Expanded(
                    child: Text('My Pollinator Log',
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  Icon(Icons.calendar_today_outlined,
                      size: 18, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 6),
                  Text('Today', style: theme.textTheme.titleSmall),
                ],
              ),
              const SizedBox(height: 24),

              // ── Section title ──
              _SectionTitle(title: 'Spotting goal', action: 'Details'),
              const SizedBox(height: 12),

              // ── Goal card ──
              _GoalCard(sightings: sightings, goal: spottingGoal),
            ],
          ),
        ),
      ),
    );
  }
}

// A title on the left + a small action link on the right.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.action});

  final String title;
  final String action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Text(action,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.primary)),
        const SizedBox(width: 4),
        Icon(Icons.arrow_forward, size: 18, color: theme.colorScheme.primary),
      ],
    );
  }
}

// The big card with the ring, like the template's diet card.
class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.sightings, required this.goal});

  final List<Sighting> sightings;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    // ── Numbers calculated from the list ──
    final total = sightings.length;
    final speciesCount = sightings.map((s) => s.species).toSet().length;
    final left = (goal - total).clamp(0, goal);
    final progress = (total / goal).clamp(0.0, 1.0);

    int countGroup(String group) =>
        sightings.where((s) => s.group == group).length;

    return GlassCard(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(68),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Left: two stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Stat(label: 'Logged', value: '$total',
                        unit: 'sightings', barColor: scheme.secondary),
                    const SizedBox(height: 12),
                    _Stat(label: 'Species', value: '$speciesCount',
                        unit: 'different', barColor: scheme.primary),
                  ],
                ),
              ),
              // Right: the ring
              SizedBox(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        strokeCap: StrokeCap.round,
                        color: scheme.primary,
                        backgroundColor: scheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$left',
                            style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.primary)),
                        Text('to goal', style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: scheme.primary.withValues(alpha: 0.12)),
          const SizedBox(height: 8),
          // Bottom: three group bars, equal width thanks to Expanded
          Row(
            children: [
              Expanded(child: _GroupBar(label: 'Bees',
                  count: countGroup('Bee'), total: total, color: scheme.secondary)),
              const SizedBox(width: 12),
              Expanded(child: _GroupBar(label: 'Butterflies',
                  count: countGroup('Butterfly'), total: total, color: scheme.tertiary)),
              const SizedBox(width: 12),
              Expanded(child: _GroupBar(label: 'Birds',
                  count: countGroup('Bird'), total: total, color: scheme.primary)),
            ],
          ),
        ],
      ),
    );
  }
}

// "Logged 5 sightings" with a small coloured line on the left.
class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value,
      required this.unit, required this.barColor});

  final String label, value, unit;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 3,
          height: 44,
          decoration: BoxDecoration(
            color: barColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodyMedium),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(width: 6),
                Text(unit, style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// "Bees" + a thin progress bar + "2 logged"
class _GroupBar extends StatelessWidget {
  const _GroupBar({required this.label, required this.count,
      required this.total, required this.color});

  final String label;
  final int count, total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final share = total == 0 ? 0.0 : count / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.titleSmall),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: share,
            minHeight: 5,
            color: color,
            backgroundColor: color.withValues(alpha: 0.2),
          ),
        ),
        const SizedBox(height: 4),
        Text('$count logged', style: theme.textTheme.bodySmall),
      ],
    );
  }
}