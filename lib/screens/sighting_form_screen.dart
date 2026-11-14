import 'package:flutter/material.dart';
import '../models/sighting.dart';

class SightingFormScreen extends StatelessWidget {
  const SightingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New sighting')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ElevatedButton(
            onPressed: () {
              // TEMPORARY: Member 2 replaces this with the real form.
              final newSighting = Sighting(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                species: 'Test bee',
                scientificName: 'Apis test',
                group: 'Bee',
                count: 1,
                plant: 'Sunflower',
                location: 'Shah Alam',
                dateTime: DateTime.now(),
              );
              Navigator.pop(context, newSighting); // send it back to the shell
            },
            child: const Text('Save test sighting'),
          ),
        ),
      ),
    );
  }
}