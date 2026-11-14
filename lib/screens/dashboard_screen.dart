import 'package:flutter/material.dart';
import '../models/sighting.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.sightings});

  final List<Sighting> sightings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Dashboard: ${sightings.length} sightings')),
    );
  }
}