// Content for the Species Detail screen, one entry per pollinator.
// Kept apart from the UI so the same screen works for every species.

class SpeciesInfo {
  const SpeciesInfo({
    required this.name,
    required this.scientificName,
    required this.drawing,
    required this.flower,
    required this.facts,
    required this.description,
    required this.bodyParts,
    required this.plants,
    this.diagram,
    this.emoji,
  });

  final String name;
  final String scientificName;
  final String drawing;   // main illustration
  final String flower;    // flower beside it
  final List<({String value, String label})> facts; // 3 fact cards
  final String description;
  final List<({String name, String detail})> bodyParts;
  final List<String> plants;
  final String? diagram;  // labelled diagram (bees only for now)
  final String? emoji;    // Norman's original emoji art (honey bee)
}

const _path = 'assets/illustrations';

const Map<String, SpeciesInfo> speciesInfo = {
  'honeybee': SpeciesInfo(
    name: 'Asian honey bee',
    scientificName: 'Apis cerana',
    drawing: '$_path/bee.svg',
    flower: '$_path/sunflower.svg',
    diagram: '$_path/bee_anatomy.svg',
    emoji: '🐝 🌻',
    facts: [
      (value: '~10 mm', label: 'Size'),
      (value: 'Daytime', label: 'Active'),
      (value: 'Hollows', label: 'Nests in'),
    ],
    description: 'A native honey bee that lives in colonies in tree hollows '
        'and wall gaps. It visits fruit trees, wildflowers and garden '
        'plants, carrying pollen home in baskets on its back legs.',
    bodyParts: [
      (name: 'Wings', detail: 'Used for flight.'),
      (name: 'Antennae', detail: 'Sense the surroundings.'),
      (name: 'Striped abdomen', detail: 'The rear section of the body.'),
      (name: 'Compound eyes', detail: 'Help detect movement and shapes.'),
      (name: 'Pollen baskets', detail: 'Carry pollen on the hind legs.'),
      (name: 'Stinger', detail: 'Used by workers for defence.'),
    ],
    plants: ['Sunflower', 'Asystasia', 'Coconut', 'Rambutan'],
  ),
  'kelulut': SpeciesInfo(
    name: 'Stingless bee',
    scientificName: 'Heterotrigona itama',
    drawing: '$_path/kelulut.svg',
    flower: '$_path/flower.svg',
    diagram: '$_path/kelulut_anatomy.svg',
    facts: [
      (value: '4-6 mm', label: 'Size'),
      (value: 'Daytime', label: 'Active'),
      (value: 'Trunks', label: 'Nests in'),
    ],
    description: 'Known in Malaysia as kelulut. A small, dark native bee '
        'kept by farmers for kelulut honey. It cannot sting and defends '
        'its nest by biting. The nest entrance is a short tube of resin.',
    bodyParts: [
      (name: 'Small dark body', detail: 'Easy to miss on flowers.'),
      (name: 'Wings', detail: 'Clear and longer than the abdomen.'),
      (name: 'Antennae', detail: 'Sense smell and touch.'),
      (name: 'Pollen baskets', detail: 'Carry pollen and resin home.'),
      (name: 'No working stinger', detail: 'Bites instead of stinging.'),
    ],
    plants: ['Asystasia', 'Ulam raja', 'Starfruit', 'Coconut'],
  ),
  'Fly': SpeciesInfo(
    name: 'Hoverfly',
    scientificName: 'Family Syrphidae',
    drawing: '$_path/hoverfly.svg',
    flower: '$_path/flower.svg',
    diagram: '$_path/hoverfly_anatomy.svg',
    facts: [
      (value: '5-15 mm', label: 'Size'),
      (value: 'Daytime', label: 'Active'),
      (value: 'Hovers', label: 'Flight'),
    ],
    description: 'A fly that copies the stripes of bees and wasps but '
        'cannot sting. It can hold still in the air, then dart to open '
        'flowers. Many hoverfly larvae eat aphids, so they help gardens too.',
    bodyParts: [
      (name: 'One pair of wings', detail: 'The easiest way to tell it from a bee.'),
      (name: 'Large eyes', detail: 'Take up most of the head.'),
      (name: 'Short antennae', detail: 'Much shorter than a bee\'s.'),
      (name: 'Striped abdomen', detail: 'Copies a bee to scare predators.'),
      (name: 'Halteres', detail: 'Tiny knobs that keep it balanced.'),
    ],
    plants: ['Lantana', 'Cosmos', 'Coriander', 'Marigold'],
  ),
  'Butterfly': SpeciesInfo(
    name: 'Common Birdwing',
    scientificName: 'Troides helena',
    drawing: '$_path/butterfly.svg',
    flower: '$_path/flower.svg',
    diagram: '$_path/butterfly_anatomy.svg',
    facts: [
      (value: '~15 cm', label: 'Wingspan'),
      (value: 'Daytime', label: 'Active'),
      (value: 'Pipevine', label: 'Host plant'),
    ],
    description: 'One of the largest butterflies in Malaysia, with black '
        'forewings and golden hindwings. It is protected under CITES. '
        'Adults drink nectar from bright garden flowers.',
    bodyParts: [
      (name: 'Proboscis', detail: 'A coiled tongue for drinking nectar.'),
      (name: 'Scaled wings', detail: 'Tiny scales give the colours.'),
      (name: 'Clubbed antennae', detail: 'Thin with a knob at the tip.'),
      (name: 'Compound eyes', detail: 'See colours, including UV.'),
      (name: 'Six legs', detail: 'Taste the flower when they land.'),
    ],
    plants: ['Ixora', 'Hibiscus', 'Lantana'],
  ),
  'Bird': SpeciesInfo(
    name: 'Olive-backed sunbird',
    scientificName: 'Cinnyris jugularis',
    drawing: '$_path/sunbird.svg',
    flower: '$_path/flower.svg',
    diagram: '$_path/sunbird_anatomy.svg',
    facts: [
      (value: '~11 cm', label: 'Size'),
      (value: 'Daytime', label: 'Active'),
      (value: 'Hanging', label: 'Nest type'),
    ],
    description: 'A small, common garden bird in Malaysia, called burung '
        'kelicap. Males have a dark blue throat and a yellow belly. It '
        'drinks nectar with a long curved bill and carries pollen on its head.',
    bodyParts: [
      (name: 'Curved bill', detail: 'Reaches deep into tube flowers.'),
      (name: 'Long tongue', detail: 'Laps up nectar.'),
      (name: 'Yellow belly', detail: 'Easy to spot in the garden.'),
      (name: 'Strong feet', detail: 'Perches while it feeds.'),
    ],
    plants: ['Hibiscus', 'Heliconia', 'Banana flower', 'Ixora'],
  ),
  'Moth': SpeciesInfo(
    name: 'Moth',
    scientificName: 'Order Lepidoptera',
    drawing: '$_path/moth.svg',
    flower: '$_path/flower.svg',
    diagram: '$_path/moth_anatomy.svg',
    facts: [
      (value: 'Varies', label: 'Size'),
      (value: 'Night', label: 'Active'),
      (value: 'Scent', label: 'Finds flowers by'),
    ],
    description: 'Most moths fly at night and visit pale, sweet-smelling '
        'flowers. They rest with their wings flat and are important '
        'night pollinators.',
    bodyParts: [
      (name: 'Feathery antennae', detail: 'Pick up scent from far away.'),
      (name: 'Furry body', detail: 'Keeps warm at night.'),
      (name: 'Proboscis', detail: 'A long tongue for nectar.'),
      (name: 'Flat wings', detail: 'Held open or flat when resting.'),
    ],
    plants: ['Jasmine', 'Frangipani', 'Moonflower'],
  ),
  'Bat': SpeciesInfo(
    name: 'Cave nectar bat',
    scientificName: 'Eonycteris spelaea',
    drawing: '$_path/bat.svg',
    flower: '$_path/flower.svg',
    diagram: '$_path/bat_anatomy.svg',
    facts: [
      (value: 'Night', label: 'Active'),
      (value: 'Caves', label: 'Roosts in'),
      (value: 'Durian', label: 'Pollinates'),
    ],
    description: 'A nectar bat that pollinates durian and petai flowers at '
        'night. Without bats like this one, Malaysia would have far '
        'fewer durians.',
    bodyParts: [
      (name: 'Long snout', detail: 'Reaches into big flowers.'),
      (name: 'Long tongue', detail: 'Laps nectar and pollen.'),
      (name: 'Furry body', detail: 'Pollen sticks to the fur.'),
      (name: 'Wings', detail: 'Skin stretched between long fingers.'),
    ],
    plants: ['Durian', 'Petai', 'Banana'],
  ),
};

/// Picks the right entry for a sighting's group and species.
SpeciesInfo infoFor({required String group, String scientificName = '', String species = ''}) {
  final text = '$scientificName $species'.toLowerCase();
  if (group == 'Bee') {
    if (text.contains('heterotrigona') ||
        text.contains('stingless') ||
        text.contains('kelulut')) {
      return speciesInfo['kelulut']!;
    }
    return speciesInfo['honeybee']!;
  }
  return speciesInfo[group] ?? speciesInfo['honeybee']!;
}