import 'package:flutter/material.dart';
import '../models/sighting.dart';
import '../widgets/glass_card.dart';
import '../widgets/glow_background.dart';

class SightingFormScreen extends StatefulWidget {
  const SightingFormScreen({
    super.key,
    this.sighting,
  });

  // null = Add mode
  // existing Sighting = Edit mode
  final Sighting? sighting;

  @override
  State<SightingFormScreen> createState() => _SightingFormScreenState();
}

class _SightingFormScreenState extends State<SightingFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _speciesController;
  late final TextEditingController _scientificNameController;
  late final TextEditingController _countController;
  late final TextEditingController _plantController;
  late final TextEditingController _locationController;
  late final TextEditingController _notesController;

  String _selectedGroup = 'Bee';
  bool _verified = false;

  final List<String> _groups = [
    'Bee',
    'Butterfly',
    'Moth',
    'Fly',
    'Bird',
    'Bat',
  ];

  bool get _isEditMode => widget.sighting != null;

  @override
  void initState() {
    super.initState();

    final sighting = widget.sighting;

    _speciesController = TextEditingController(
      text: sighting?.species ?? '',
    );

    _scientificNameController = TextEditingController(
      text: sighting?.scientificName ?? '',
    );

    _countController = TextEditingController(
      text: sighting != null ? sighting.count.toString() : '',
    );

    _plantController = TextEditingController(
      text: sighting?.plant ?? '',
    );

    _locationController = TextEditingController(
      text: sighting?.location ?? '',
    );

    _notesController = TextEditingController(
      text: sighting?.notes ?? '',
    );

    if (sighting != null) {
      _selectedGroup = sighting.group;
      _verified = sighting.verified;
    }
  }

  @override
  void dispose() {
    _speciesController.dispose();
    _scientificNameController.dispose();
    _countController.dispose();
    _plantController.dispose();
    _locationController.dispose();
    _notesController.dispose();

    super.dispose();
  }

  void _saveSighting() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final oldSighting = widget.sighting;

    final newSighting = Sighting(
      id: oldSighting?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      species: _speciesController.text.trim(),
      scientificName: _scientificNameController.text.trim(),
      group: _selectedGroup,
      count: int.parse(_countController.text.trim()),
      plant: _plantController.text.trim(),
      location: _locationController.text.trim(),
      dateTime: oldSighting?.dateTime ?? DateTime.now(),
      notes: _notesController.text.trim(),
      verified: _verified,
      imagePath: oldSighting?.imagePath,
    );

    // Return the new/edited Sighting to SightingsLogScreen.
    Navigator.pop(context, newSighting);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Sighting' : 'New Sighting',
        ),
      ),
      body: GlowBackground(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
              children: [
                Text(
                  _isEditMode
                      ? 'Update your sighting'
                      : 'Record a new pollinator sighting',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _isEditMode
                      ? 'Edit the information below and save your changes.'
                      : 'Enter the details of the pollinator you observed.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: 20),

                const _PhotoPlaceholder(),
                const SizedBox(height: 20),

                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Species
                      _FieldLabel(label: 'Species'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _speciesController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Asian Honey Bee',
                          prefixIcon: Icon(Icons.pets_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the species name';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Scientific name
                      _FieldLabel(label: 'Scientific Name'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _scientificNameController,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Apis cerana',
                          prefixIcon: Icon(Icons.science_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the scientific name';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Group
                      _FieldLabel(label: 'Group'),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<String>(
                        initialValue: _selectedGroup,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        items: _groups.map((group) {
                          return DropdownMenuItem(
                            value: group,
                            child: Text(group),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedGroup = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a group';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Count
                      _FieldLabel(label: 'Count'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _countController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'e.g. 3',
                          prefixIcon: Icon(Icons.numbers_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the number observed';
                          }

                          final count = int.tryParse(value.trim());

                          if (count == null) {
                            return 'Please enter a valid number';
                          }

                          if (count < 1) {
                            return 'Count must be at least 1';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Plant
                      _FieldLabel(label: 'Plant'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _plantController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Sunflower',
                          prefixIcon: Icon(Icons.local_florist_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the plant';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Location
                      _FieldLabel(label: 'Location'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _locationController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'e.g. MSU Shah Alam',
                          prefixIcon: Icon(Icons.location_on_outlined),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the location';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      // Notes
                      _FieldLabel(label: 'Notes'),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _notesController,
                        maxLines: 4,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: 'Add any additional observations...',
                          prefixIcon: Icon(Icons.notes_outlined),
                          alignLabelWithHint: true,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Verified switch
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Verified sighting',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          'Mark this sighting as verified.',
                        ),
                        value: _verified,
                        onChanged: (value) {
                          setState(() {
                            _verified = value;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _saveSighting,
                          icon: const Icon(Icons.save_outlined),
                          label: Text(
                            _isEditMode
                                ? 'Save Changes'
                                : 'Save Sighting',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      label,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
/// Photo area for the sighting. Practical 1 shows the layout only.
/// Practical 2 will open the camera here and save the path to imagePath.
class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Camera will be added in Practical 2'),
            ),
          );
        },
        child: Ink(
          height: 170,
          decoration: BoxDecoration(
            color: scheme.secondary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Icon(Icons.photo_camera_outlined,
                    size: 30, color: scheme.primary),
              ),
              const SizedBox(height: 12),
              Text('Add a photo',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('A clear photo helps others confirm the species',
                  style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}