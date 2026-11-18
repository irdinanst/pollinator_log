import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/sighting.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';
import 'login_screen.dart';

const _path = 'assets/illustrations';

/// One achievement. Named Achievement so it does not clash with
/// Flutter's own Badge widget.
class Achievement {
  const Achievement({
    required this.title,
    required this.description,
    required this.drawing,
    required this.progress,
    required this.target,
  });

  final String title;
  final String description;
  final String drawing;
  final int progress;
  final int target;

  bool get unlocked => progress >= target;
}

// Turns a picture grey (used for locked achievements).
const _greyscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.sightings});

  final List<Sighting> sightings;

  List<Achievement> _achievements() {
    int group(String g) => sightings.where((s) => s.group == g).length;
    final kelulut = sightings.where((s) {
      final t = '${s.species} ${s.scientificName}'.toLowerCase();
      return t.contains('heterotrigona') ||
          t.contains('stingless') ||
          t.contains('kelulut');
    }).length;
    final groups = sightings.map((s) => s.group).toSet().length;

    return [
      Achievement(
          title: 'First Sighting',
          description: 'Log your first pollinator',
          drawing: '$_path/flower.svg',
          progress: sightings.length,
          target: 1),
      Achievement(
          title: 'Bee Buddy',
          description: 'Log 3 bee sightings',
          drawing: '$_path/bee.svg',
          progress: group('Bee'),
          target: 3),
      Achievement(
          title: 'Kelulut Friend',
          description: 'Spot a stingless bee',
          drawing: '$_path/kelulut.svg',
          progress: kelulut,
          target: 1),
      Achievement(
          title: 'Butterfly Watcher',
          description: 'Log 2 butterflies',
          drawing: '$_path/butterfly.svg',
          progress: group('Butterfly'),
          target: 2),
      Achievement(
          title: 'Explorer',
          description: 'See 4 different groups',
          drawing: '$_path/sunbird.svg',
          progress: groups,
          target: 4),
      Achievement(
          title: 'Dedicated Spotter',
          description: 'Log 10 sightings',
          drawing: '$_path/sunflower.svg',
          progress: sightings.length,
          target: 10),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final achievements = _achievements();
    final unlocked = achievements.where((a) => a.unlocked).length;
    final species = sightings.map((s) => s.species).toSet().length;
    final groups = sightings.map((s) => s.group).toSet().length;

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            children: [
              // Header: drawn avatar + name
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFE6A3), Color(0xFFF2B83A)],
                      ),
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: scheme.secondary.withValues(alpha: 0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset('$_path/bee.svg'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pollinator Spotter',
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        Text('Citizen scientist · SDG 15',
                            style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Stats
              GlassCard(
                child: Row(
                  children: [
                    _StatItem(value: '${sightings.length}', label: 'Sightings'),
                    _StatItem(value: '$species', label: 'Species'),
                    _StatItem(value: '$groups', label: 'Groups'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Achievements header + overall progress
              Row(
                children: [
                  Expanded(
                    child: Text('Achievements',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Text('$unlocked / ${achievements.length} unlocked',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: scheme.primary)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: unlocked / achievements.length,
                  minHeight: 6,
                  color: scheme.secondary,
                  backgroundColor: scheme.secondary.withValues(alpha: 0.2),
                ),
              ),
              const SizedBox(height: 14),

              // 2 columns on phones, 3 on wider screens
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 600 ? 3 : 2;
                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.82,
                    children: [
                      for (final a in achievements) _AchievementTile(a: a),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () {
                  // Clear every screen and go back to Login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary)),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.a});
  final Achievement a;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final done = a.unlocked;

    // The drawing in a white circle. Locked = grey and faded with a lock.
    final picture = Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 76,
          height: 76,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: done
              ? SvgPicture.asset(a.drawing)
              : Opacity(
                  opacity: 0.45,
                  child: ColorFiltered(
                    colorFilter: _greyscale,
                    child: SvgPicture.asset(a.drawing),
                  ),
                ),
        ),
        if (!done)
          Positioned(
            right: -2,
            bottom: -2,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: scheme.surfaceContainerHighest,
              child: Icon(Icons.lock, size: 14, color: scheme.outline),
            ),
          ),
        if (done)
          Positioned(
            right: -2,
            bottom: -2,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: scheme.primary,
              child: Icon(Icons.check, size: 15, color: scheme.secondary),
            ),
          ),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: done
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFFF3C9),
                  scheme.secondary.withValues(alpha: 0.45),
                ],
              )
            : null,
        color: done ? null : Colors.white.withValues(alpha: 0.55),
        border: Border.all(
          color: done
              ? scheme.secondary
              : Colors.white.withValues(alpha: 0.9),
          width: done ? 1.5 : 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          picture,
          const SizedBox(height: 12),
          Text(a.title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: done ? null : scheme.outline,
              )),
          const SizedBox(height: 4),
          Text(a.description,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: theme.textTheme.bodySmall),
          if (!done) ...[
            const SizedBox(height: 8),
            // Progress towards this one, e.g. 2 of 3
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (a.progress / a.target).clamp(0.0, 1.0),
                      minHeight: 5,
                      color: scheme.primary,
                      backgroundColor: scheme.primary.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${a.progress.clamp(0, a.target)}/${a.target}',
                    style: theme.textTheme.labelSmall),
              ],
            ),
          ],
        ],
      ),
    );
  }
}