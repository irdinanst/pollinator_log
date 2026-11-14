import 'package:flutter/material.dart';
import '../models/sighting.dart';
import '../data/dummy_sightings.dart';
import 'dashboard_screen.dart';
import 'sightings_log_screen.dart';
import 'sighting_form_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;                              
  final List<Sighting> _sightings = List.of(dummySightings); 

  Future<void> _addSighting() async {
    final Sighting? result = await Navigator.push<Sighting>(
      context,
      MaterialPageRoute(builder: (_) => const SightingFormScreen()),
    );
    if (result != null) {
      setState(() => _sightings.insert(0, result)); // newest first
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(sightings: _sightings),
      SightingsLogScreen(sightings: _sightings),
      const Center(child: Text('Guide (coming soon)')),
      const Center(child: Text('Profile (coming soon)')),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSighting,
        shape: const CircleBorder(),
        tooltip: 'Add sighting',
        child: const Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), activeIcon: Icon(Icons.list_alt), label: 'Log'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Guide'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}