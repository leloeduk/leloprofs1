import 'package:flutter/material.dart';
import '../../domain/models/school_model.dart';

class EditSchoolPage extends StatefulWidget {
  final SchoolModel school;

  const EditSchoolPage({super.key, required this.school});

  @override
  State<EditSchoolPage> createState() => _EditSchoolPageState();
}

class _EditSchoolPageState extends State<EditSchoolPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _townController;
  late TextEditingController _departmentController;
  late TextEditingController _countryController;
  late TextEditingController _primaryPhoneController;
  late TextEditingController _secondaryPhoneController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _yearOfEstablishmentController;
  late TextEditingController _bioController;

  List<String> _types = [];
  List<String> _jobPosts = [];
  List<String> _educationCycle = [];

  bool _isActive = true;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    final s = widget.school;

    _nameController = TextEditingController(text: s.name);
    _townController = TextEditingController(text: s.town);
    _departmentController = TextEditingController(text: s.department);
    _countryController = TextEditingController(text: s.country);
    _primaryPhoneController = TextEditingController(text: s.primaryPhone);
    _secondaryPhoneController = TextEditingController(
      text: s.secondaryPhone ?? '',
    );
    _emergencyPhoneController = TextEditingController(
      text: s.emergencyPhone ?? '',
    );
    _yearOfEstablishmentController = TextEditingController(
      text: s.yearOfEstablishment.toString(),
    );
    _bioController = TextEditingController(text: s.bio ?? '');

    _types = List.from(s.types);
    _jobPosts = List.from(s.jobPosts);
    _educationCycle = List.from(s.educationCycle);

    _isActive = s.isActive;
    _isVerified = s.isVerified;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _townController.dispose();
    _departmentController.dispose();
    _countryController.dispose();
    _primaryPhoneController.dispose();
    _secondaryPhoneController.dispose();
    _emergencyPhoneController.dispose();
    _yearOfEstablishmentController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final updatedSchool = SchoolModel(
      id: widget.school.id,
      email: widget.school.email,
      name: _nameController.text.trim(),
      town: _townController.text.trim(),
      department: _departmentController.text.trim(),
      country: _countryController.text.trim(),
      primaryPhone: _primaryPhoneController.text.trim(),
      secondaryPhone:
          _secondaryPhoneController.text.trim().isEmpty
              ? null
              : _secondaryPhoneController.text.trim(),
      emergencyPhone:
          _emergencyPhoneController.text.trim().isEmpty
              ? null
              : _emergencyPhoneController.text.trim(),
      isActive: _isActive,
      isVerified: _isVerified,
      createdAt: widget.school.createdAt,
      creationSource: widget.school.creationSource,
      schoolCreationDate: widget.school.schoolCreationDate,
      yearOfEstablishment: int.parse(
        _yearOfEstablishmentController.text.trim(),
      ),
      jobPosts: _jobPosts,
      types: _types,
      ratings: widget.school.ratings,
      educationCycle: _educationCycle,
      bio:
          _bioController.text.trim().isEmpty
              ? null
              : _bioController.text.trim(),
      role: '',
    );

    Navigator.of(context).pop(updatedSchool);
  }

  Future<void> _editListDialog(String title, List<String> list) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Modifier $title'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  children:
                      list.map((item) {
                        return Chip(
                          label: Text(item),
                          onDeleted: () {
                            setState(() => list.remove(item));
                            Navigator.pop(context);
                            _editListDialog(
                              title,
                              list,
                            ); // relancer le dialogue
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(labelText: 'Nouvel élément'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newItem = controller.text.trim();
                  if (newItem.isNotEmpty) {
                    setState(() => list.add(newItem));
                  }
                  Navigator.pop(context);
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildListEditButton(
    String label,
    List<String> list,
    VoidCallback onEdit,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedButton.icon(
          icon: const Icon(Icons.edit),
          label: Text('$label (${list.length})'),
          onPressed: onEdit,
        ),
        Wrap(
          spacing: 8,
          children: list.map((e) => Chip(label: Text(e))).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier École'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _save)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle('Informations Générales'),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Nom'),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Champ obligatoire'
                                    : null,
                      ),
                      TextFormField(
                        controller: _townController,
                        decoration: const InputDecoration(labelText: 'Ville'),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Champ obligatoire'
                                    : null,
                      ),
                      TextFormField(
                        controller: _departmentController,
                        decoration: const InputDecoration(
                          labelText: 'Département',
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Champ obligatoire'
                                    : null,
                      ),
                      TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(labelText: 'Pays'),
                      ),
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(
                          labelText: 'Biographie',
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle('Téléphones'),
                      TextFormField(
                        controller: _primaryPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone principal',
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Champ obligatoire'
                                    : null,
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        controller: _secondaryPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone secondaire',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      TextFormField(
                        controller: _emergencyPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone d\'urgence',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _sectionTitle('Détails Supplémentaires'),
                      TextFormField(
                        controller: _yearOfEstablishmentController,
                        decoration: const InputDecoration(
                          labelText: 'Année de création',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return 'Champ obligatoire';
                          if (int.tryParse(v) == null)
                            return 'Doit être un nombre';
                          return null;
                        },
                      ),
                      SwitchListTile(
                        title: const Text('École active'),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                      SwitchListTile(
                        title: const Text('École vérifiée'),
                        value: _isVerified,
                        onChanged: (v) => setState(() => _isVerified = v),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Listes associées'),
                      _buildListEditButton(
                        'Types',
                        _types,
                        () => _editListDialog('Types', _types),
                      ),
                      _buildListEditButton(
                        'Postes d\'emploi',
                        _jobPosts,
                        () => _editListDialog('Postes d\'emploi', _jobPosts),
                      ),
                      _buildListEditButton(
                        'Cycles d\'éducation',
                        _educationCycle,
                        () => _editListDialog(
                          'Cycles d\'éducation',
                          _educationCycle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
