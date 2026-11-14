import 'package:flutter/material.dart';
import '../models/sighting.dart';

class SightingsLogScreen extends StatelessWidget {
  const SightingsLogScreen({super.key, required this.sightings});

  final List<Sighting> sightings; // given to us by the shell

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Log: ${sightings.length} sighting')),
    );
  }
}