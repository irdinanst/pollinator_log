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

  // ADD: open an empty form, add the result to the top of the list
  Future<void> _addSighting() async {
    final Sighting? result = await Navigator.push<Sighting>(
      context,
      MaterialPageRoute(builder: (_) => const SightingFormScreen()),
    );
    if (result != null) {
      setState(() => _sightings.insert(0, result));
    }
  }

  // EDIT: open the form filled with this sighting, replace it with the result
  Future<void> _editSighting(Sighting old) async {
    final Sighting? result = await Navigator.push<Sighting>(
      context,
      MaterialPageRoute(builder: (_) => SightingFormScreen(sighting: old)),
    );
    if (result != null) {
      setState(() {
        final index = _sightings.indexWhere((s) => s.id == old.id);
        if (index != -1) _sightings[index] = result;
      });
    }
  }

  // DELETE: remove it from the list
  void _deleteSighting(Sighting sighting) {
    setState(() => _sightings.removeWhere((s) => s.id == sighting.id));
  }
    // UNDO: put a deleted sighting back where it was
  void _restoreSighting(Sighting sighting, int index) {
    setState(() {
      final safeIndex = index.clamp(0, _sightings.length);
      _sightings.insert(safeIndex, sighting);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(sightings: _sightings),
      SightingsLogScreen(
        sightings: _sightings,
        onAdd: _addSighting,
        onEdit: _editSighting,
        onDelete: _deleteSighting,
        onRestore: _restoreSighting,
      ),
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