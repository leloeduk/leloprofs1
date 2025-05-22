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

  // Pour les listes (types, jobPosts, educationCycle), tu peux gérer via TextField + bouton Ajouter, ou un widget spécialisé
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
      uid: widget.school.uid,
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
      profileImage: widget.school.profileImage,
      jobPosts: _jobPosts,
      types: _types,
      ratings: widget.school.ratings,
      educationCycle: _educationCycle,
      bio:
          _bioController.text.trim().isEmpty
              ? null
              : _bioController.text.trim(),
    );

    // Ici tu peux faire la mise à jour Firestore, par exemple :
    // FirebaseFirestore.instance.collection('schools').doc(updatedSchool.uid).update(updatedSchool.toMap());

    Navigator.of(context).pop(updatedSchool);
  }

  // Exemple simple pour éditer une liste de String via un AlertDialog
  Future<void> _editList(String title, List<String> list) async {
    final TextEditingController _itemController = TextEditingController();
    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Modifier $title'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var item in list)
                  ListTile(
                    title: Text(item),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          list.remove(item);
                        });
                        Navigator.of(context).pop();
                        _editList(title, list); // relancer pour mise à jour
                      },
                    ),
                  ),
                TextField(
                  controller: _itemController,
                  decoration: InputDecoration(labelText: 'Ajouter un élément'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (_itemController.text.trim().isNotEmpty) {
                    setState(() {
                      list.add(_itemController.text.trim());
                    });
                  }
                  Navigator.of(context).pop();
                },
                child: Text('Ajouter'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fermer'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier École'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _save)],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Champs texte simples
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _townController,
                decoration: InputDecoration(labelText: 'Ville'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(labelText: 'Département'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
              ),
              TextFormField(
                controller: _countryController,
                decoration: InputDecoration(labelText: 'Pays'),
              ),
              TextFormField(
                controller: _primaryPhoneController,
                decoration: InputDecoration(labelText: 'Téléphone principal'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Champ obligatoire' : null,
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _secondaryPhoneController,
                decoration: InputDecoration(labelText: 'Téléphone secondaire'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emergencyPhoneController,
                decoration: InputDecoration(labelText: 'Téléphone d\'urgence'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _yearOfEstablishmentController,
                decoration: InputDecoration(labelText: 'Année de création'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Champ obligatoire';
                  if (int.tryParse(v) == null) return 'Doit être un nombre';
                  return null;
                },
              ),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(labelText: 'Biographie'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Switch pour isActive et isVerified
              SwitchListTile(
                title: Text('Actif'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              SwitchListTile(
                title: Text('Vérifié'),
                value: _isVerified,
                onChanged: (v) => setState(() => _isVerified = v),
              ),

              const SizedBox(height: 16),

              // Boutons pour éditer listes
              ElevatedButton(
                onPressed: () => _editList('Types', _types),
                child: Text('Modifier Types (${_types.length})'),
              ),
              ElevatedButton(
                onPressed: () => _editList('Postes d\'emploi', _jobPosts),
                child: Text('Modifier Postes d\'emploi (${_jobPosts.length})'),
              ),
              ElevatedButton(
                onPressed:
                    () => _editList('Cycles d\'éducation', _educationCycle),
                child: Text(
                  'Modifier Cycles d\'éducation (${_educationCycle.length})',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
