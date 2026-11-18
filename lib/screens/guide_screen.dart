import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';

const _path = 'assets/illustrations';

/// One pollinator group shown in the guide.
class PollinatorGroup {
  const PollinatorGroup({
    required this.name,
    required this.malayName,
    required this.drawing,
    required this.tint,
    required this.examples,
    required this.tips,
    this.diagram,
  });

  final String name;
  final String malayName;
  final String drawing;     // illustration in the circle
  final Color tint;         // circle background colour
  final String examples;    // common species in Malaysia
  final List<String> tips;  // how to recognise
  final String? diagram;    // labelled body diagram (bees)
}

const List<PollinatorGroup> pollinatorGroups = [
  PollinatorGroup(
    name: 'Bees',
    malayName: 'Lebah & Kelulut',
    drawing: '$_path/bee.svg',
    tint: Color(0xFFFFE6A3),
    diagram: '$_path/bee_anatomy.svg',
    examples: 'Asian honey bee (Apis cerana), stingless bee / kelulut '
        '(Heterotrigona itama)',
    tips: [
      'Two pairs of wings and long antennae',
      'Often carry yellow pollen on their back legs',
      'Kelulut are small, dark and do not sting',
    ],
  ),
  PollinatorGroup(
    name: 'Butterflies',
    malayName: 'Rama-rama',
    drawing: '$_path/butterfly.svg',
    diagram: '$_path/butterfly_anatomy.svg',
    tint: Color(0xFFFBDCCB),
    examples: 'Common Birdwing (Troides helena), Plain Tiger '
        '(Danaus chrysippus)',
    tips: [
      'Active on sunny days',
      'Antennae end in a small knob',
      'Usually rest with wings closed upright',
    ],
  ),
  PollinatorGroup(
    name: 'Moths',
    malayName: 'Kupu-kupu',
    drawing: '$_path/moth.svg',
    diagram: '$_path/moth_anatomy.svg',
    tint: Color(0xFFEDE1D2),
    examples: 'Hawk moths (family Sphingidae)',
    tips: [
      'Most fly at night',
      'Feathery or thin antennae with no knob',
      'Rest with wings held flat',
    ],
  ),
  PollinatorGroup(
    name: 'Flies',
    malayName: 'Lalat',
    drawing: '$_path/hoverfly.svg',
    diagram: '$_path/hoverfly_anatomy.svg',
    tint: Color(0xFFD9EDD3),
    examples: 'Hoverflies (family Syrphidae)',
    tips: [
      'Only one pair of wings',
      'Can hover still in the air',
      'Short antennae and very large eyes',
    ],
  ),
  PollinatorGroup(
    name: 'Birds',
    malayName: 'Burung kelicap',
    drawing: '$_path/sunbird.svg',
    diagram: '$_path/sunbird_anatomy.svg',
    tint: Color(0xFFD6E7F5),
    examples: 'Olive-backed sunbird (Cinnyris jugularis)',
    tips: [
      'Long, thin, curved bill',
      'Visits hibiscus and banana flowers',
      'Males have a dark blue throat',
    ],
  ),
  PollinatorGroup(
    name: 'Bats',
    malayName: 'Kelawar',
    drawing: '$_path/bat.svg',
    diagram: '$_path/bat_anatomy.svg',
    tint: Color(0xFFE3DCEA),
    examples: 'Cave nectar bat (Eonycteris spelaea)',
    tips: [
      'Feed at night on large flowers',
      'Pollinate durian and petai',
      'Long snout and long tongue',
    ],
  ),
];

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            // header + tip card + one card per group
            itemCount: pollinatorGroups.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pollinator Guide',
                          style: theme.textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(
                          'Who visits Malaysian flowers? Tap a group to learn more.',
                          style: theme.textTheme.bodyMedium),
                    ],
                  ),
                );
              }
              if (index == 1) return const _TipCard();
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _GroupCard(group: pollinatorGroups[index - 2]),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Bee vs hoverfly, side by side with the drawings.
class _TipCard extends StatelessWidget {
  const _TipCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.secondary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.secondary.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: scheme.primary),
              const SizedBox(width: 10),
              Text('Bee or hoverfly?',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _Compare(
                  asset: '$_path/bee.svg',
                  title: 'Bee',
                  text: 'Two pairs of wings, long antennae',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Compare(
                  asset: '$_path/hoverfly.svg',
                  title: 'Hoverfly',
                  text: 'One pair of wings, hovers in one spot',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Compare extends StatelessWidget {
  const _Compare({required this.asset, required this.title, required this.text});
  final String asset;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SizedBox(height: 56, child: SvgPicture.asset(asset)),
          const SizedBox(height: 6),
          Text(title,
              style: theme.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(text,
              textAlign: TextAlign.center, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.group});
  final PollinatorGroup group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return GlassCard(
      padding: EdgeInsets.zero,
      // Material: ExpansionTile needs one to draw its ripple
      child: Material(
        type: MaterialType.transparency,
        child: Theme(
          // removes the lines ExpansionTile draws when open
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            leading: Container(
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: group.tint,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(group.drawing),
            ),
            title: Text(group.name,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(group.malayName,
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic)),
            children: [
              // Labelled body diagram (only groups that have one)
              if (group.diagram != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AspectRatio(
                    aspectRatio: 340 / 220,
                    child: SvgPicture.asset(
                      group.diagram!,
                      semanticsLabel: 'Labelled diagram of ${group.name} body parts',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Text('Common in Malaysia',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: scheme.primary)),
              const SizedBox(height: 4),
              Text(group.examples, style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              Text('How to recognise',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(color: scheme.primary)),
              const SizedBox(height: 4),
              for (final tip in group.tips)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 18, color: scheme.secondary),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(tip, style: theme.textTheme.bodySmall)),
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