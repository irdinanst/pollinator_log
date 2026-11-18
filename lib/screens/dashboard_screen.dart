import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/sighting.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';

// Look of each pollinator group: drawing + card gradient (light to dark).
const Map<String, ({String label, String asset, Color light, Color dark})>
    groupStyles = {
  'Bee': (label: 'Bees', asset: 'assets/illustrations/bee.svg',
      light: Color(0xFFFFE6A3), dark: Color(0xFFF2B83A)),
  'Butterfly': (label: 'Butterflies', asset: 'assets/illustrations/butterfly.svg',
      light: Color(0xFFFBDCCB), dark: Color(0xFFE9A07E)),
  'Bird': (label: 'Birds', asset: 'assets/illustrations/sunbird.svg',
      light: Color(0xFFD6E7F5), dark: Color(0xFF8DB8DA)),
  'Fly': (label: 'Flies', asset: 'assets/illustrations/hoverfly.svg',
      light: Color(0xFFD9EDD3), dark: Color(0xFF8FC48B)),
  'Moth': (label: 'Moths', asset: 'assets/illustrations/moth.svg',
      light: Color(0xFFEDE1D2), dark: Color(0xFFC7A27C)),
  'Bat': (label: 'Bats', asset: 'assets/illustrations/bat.svg',
      light: Color(0xFFE3DCEA), dark: Color(0xFFA997BC)),
};

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

// Same card shape everywhere: small corners, one big top-right corner.
const _leafShape = BorderRadius.only(
  topLeft: Radius.circular(10),
  topRight: Radius.circular(54),
  bottomLeft: Radius.circular(10),
  bottomRight: Radius.circular(10),
);

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.sightings, this.onGroupTap});

  final List<Sighting> sightings;
  final ValueChanged<String>? onGroupTap;
  static const int spottingGoal = 10; // per 7 days

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // null = follow the newest sighting. The arrows set a fixed day.
  DateTime? _picked;

  DateTime get _day {
    if (_picked != null) return _picked!;
    if (widget.sightings.isEmpty) return DateTime.now();
    return widget.sightings
        .map((s) => s.dateTime)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  void _moveDay(int days) =>
      setState(() => _picked = _day.add(Duration(days: days)));

  // Sightings in the 7 days that end on the chosen day
  List<Sighting> _week() {
    final d = _day;
    final end = DateTime(d.year, d.month, d.day + 1);
    final start = end.subtract(const Duration(days: 7));
    return widget.sightings
        .where((s) => !s.dateTime.isBefore(start) && s.dateTime.isBefore(end))
        .toList();
  }

  // Newest 3 sightings
  List<Sighting> _recent() {
    final copy = [...widget.sightings]
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return copy.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sightings = widget.sightings;
    final day = _day;

    // Flower visits: how many sightings on each plant
    final Map<String, int> visits = {};
    for (final s in sightings) {
      visits[s.plant] = (visits[s.plant] ?? 0) + 1;
    }
    final topPlants = visits.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    const groups = ['Bee', 'Butterfly', 'Bird', 'Fly'];

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header (glass, stays at the top)
              _GlassHeader(
                dateLabel: '${day.day} ${_months[day.month - 1]}',
                onPrev: () => _moveDay(-1),
                onNext: () => _moveDay(1),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                  children: [
                    const _SectionTitle(
                        title: 'Weekly spotting goal', action: '7 days'),
                    const SizedBox(height: 12),
                    _GoalCard(
                        sightings: _week(), goal: DashboardScreen.spottingGoal),
                    const SizedBox(height: 28),

                    // Pollinator groups (pop-out drawings)
                    const _SectionTitle(
                        title: 'Your pollinator groups', action: 'Slide'),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 200, // room for the circle sticking out
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final g = groups[index];
                          final count =
                              sightings.where((s) => s.group == g).length;
                          return Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: _GroupCard(
                              group: g,
                              count: count,
                              onTap: () => widget.onGroupTap?.call(g),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Conditions + flower visits side by side
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(child: _ConditionsCard()),
                          const SizedBox(width: 14),
                          Expanded(child: _FlowerVisitsCard(top: topPlants)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Recent sightings
                    const _SectionTitle(
                        title: 'Recent sightings', action: 'Newest first'),
                    const SizedBox(height: 12),
                    ..._recent().map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _RecentTile(sighting: s),
                      ),
                    ),
                    if (sightings.isEmpty)
                      Text('No sightings yet. Tap + to log your first one.',
                          style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 18),

                    const _TipCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Glass header with date arrows
class _GlassHeader extends StatelessWidget {
  const _GlassHeader({
    required this.dateLabel,
    required this.onPrev,
    required this.onNext,
  });

  final String dateLabel;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 8, 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.45),
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.8)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text('My Pollinator Log',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              IconButton(
                tooltip: 'Previous day',
                onPressed: onPrev,
                icon: const Icon(Icons.chevron_left),
              ),
              Text(dateLabel,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              IconButton(
                tooltip: 'Next day',
                onPressed: onNext,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.sightings, required this.goal});

  final List<Sighting> sightings;
  final int goal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
              // The ring: thin track, arc, honey dot, white centre
              SizedBox(
                width: 124,
                height: 124,
                child: CustomPaint(
                  painter: _RingPainter(
                    progress: progress,
                    track: scheme.primary.withValues(alpha: 0.12),
                    arc: scheme.primary,
                    dot: scheme.secondary,
                  ),
                  child: Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.12),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$left',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.primary)),
                          Text('to goal', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: scheme.primary.withValues(alpha: 0.12)),
          const SizedBox(height: 8),
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

/// Paints the goal ring. cos/sin turn the end angle into the dot's x/y.
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.track,
    required this.arc,
    required this.dot,
  });

  final double progress;
  final Color track, arc, dot;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 9;

    canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = track
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke);

    const start = -math.pi / 2; // 12 o'clock
    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        Paint()
          ..color = arc
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round);

    final end = start + sweep;
    final dotAt = Offset(center.dx + radius * math.cos(end),
        center.dy + radius * math.sin(end));
    canvas.drawCircle(dotAt, 9, Paint()..color = Colors.white);
    canvas.drawCircle(dotAt, 6.5, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

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

// Group card: gradient card + drawing in a white circle popping out the top
class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.count,
    required this.onTap,
  });

  final String group;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = groupStyles[group]!;

    return SizedBox(
      width: 132,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. The card, pushed down 36px to leave room for the circle
          Positioned.fill(
            top: 36,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [style.light, style.dark],
                ),
                borderRadius: _leafShape,
                boxShadow: [
                  BoxShadow(
                    color: style.dark.withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              // Material + InkWell so the tap ripple shows on the gradient
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: _leafShape,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 50, 14, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(style.label,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text('$count',
                                style: theme.textTheme.headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 4),
                            Text('seen', style: theme.textTheme.bodySmall),
                          ],
                        ),
                        Text('Tap to view',
                            style: theme.textTheme.labelSmall),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // 2. White circle with the drawing, half outside the card
          Positioned(
            top: 0,
            left: 10,
            child: IgnorePointer(
              child: Container(
                width: 76,
                height: 76,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SvgPicture.asset(style.asset),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Spotting conditions: fixed sample for Practical 1.
// Practical 2 can fill it from the phone's location + a weather API.
class _ConditionsCard extends StatelessWidget {
  const _ConditionsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Spotting conditions', style: theme.textTheme.labelLarge),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.wb_sunny_rounded,
                  color: theme.colorScheme.secondary, size: 28),
              const SizedBox(width: 8),
              Text('31°C',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Sunny, light wind. Best window 8 to 11 AM.',
              style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

// Flower visits: top 3 plants from the log
class _FlowerVisitsCard extends StatelessWidget {
  const _FlowerVisitsCard({required this.top});
  final List<MapEntry<String, int>> top;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Flower visits', style: theme.textTheme.labelLarge),
          const SizedBox(height: 10),
          if (top.isEmpty)
            Text('No visits yet', style: theme.textTheme.bodySmall),
          for (final e in top.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(Icons.local_florist,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(e.key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall),
                  ),
                  Text('${e.value}',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RecentTile extends StatelessWidget {
  const _RecentTile({required this.sighting});

  final Sighting sighting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = groupStyles[sighting.group];

    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: (style?.light ?? scheme.secondary.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: style == null
                ? Icon(Icons.emoji_nature, color: scheme.primary)
                : SvgPicture.asset(style.asset),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sighting.species,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text('${sighting.plant} · ${sighting.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Text('×${sighting.count}',
              style: theme.textTheme.titleMedium?.copyWith(
                  color: scheme.primary, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: SvgPicture.asset('assets/illustrations/flower.svg'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: plant Asystasia or lantana near your home to attract more bees and butterflies.',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
