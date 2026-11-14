class Sighting {
  final String id;
  final String species;
  final String scientificName;
  final String group;      // Bee, Butterfly, Moth, Fly, Bird, Bat
  final int count;
  final String plant;
  final String location;   // text now, GPS in Practical 2
  final DateTime dateTime;
  final String notes;
  final bool verified;     // "Verified" or "Needs ID"
  final String? imagePath; // null now, camera in Practical 2

  const Sighting({
    required this.id,
    required this.species,
    required this.scientificName,
    required this.group,
    required this.count,
    required this.plant,
    required this.location,
    required this.dateTime,
    this.notes = '',
    this.verified = false,
    this.imagePath,
  });
}