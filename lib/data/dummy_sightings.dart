import '../models/sighting.dart';

final List<Sighting> dummySightings = [
  Sighting(id: '1', species: 'Stingless bee', scientificName: 'Heterotrigona itama',
      group: 'Bee', count: 6, plant: 'Asystasia', location: 'MSU garden',
      dateTime: DateTime(2026, 11, 12, 9, 40), verified: true),
  Sighting(id: '2', species: 'Hoverfly', scientificName: 'Family Syrphidae',
      group: 'Fly', count: 3, plant: 'Lantana', location: 'Shah Alam Lake Gardens',
      dateTime: DateTime(2026, 11, 12, 8, 15)),
  Sighting(id: '3', species: 'Common Birdwing', scientificName: 'Troides helena',
      group: 'Butterfly', count: 1, plant: 'Ixora', location: 'FRIM Kepong',
      dateTime: DateTime(2026, 11, 11, 16, 15), verified: true),
  Sighting(id: '4', species: 'Asian honey bee', scientificName: 'Apis cerana',
      group: 'Bee', count: 4, plant: 'Sunflower', location: 'Taman Botani Negara',
      dateTime: DateTime(2026, 11, 11, 10, 5), verified: true),
  Sighting(id: '5', species: 'Olive-backed sunbird', scientificName: 'Cinnyris jugularis',
      group: 'Bird', count: 2, plant: 'Hibiscus', location: 'Shah Alam',
      dateTime: DateTime(2026, 11, 10, 7, 30)),
];