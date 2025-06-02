import 'package:flutter/material.dart';

import '../../domain/models/teacher_model.dart';

// --- Ajout ici de TeacherSearchPage ---
class TeacherSearchPage extends StatefulWidget {
  final List<TeacherModel> allTeachers;
  const TeacherSearchPage({super.key, required this.allTeachers});

  @override
  State<TeacherSearchPage> createState() => _TeacherSearchPageState();
}

class _TeacherSearchPageState extends State<TeacherSearchPage> {
  List<TeacherModel> filteredTeachers = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    filteredTeachers = widget.allTeachers;
  }

  void updateSearch(String input) {
    setState(() {
      query = input.toLowerCase();
      filteredTeachers =
          widget.allTeachers.where((teacher) {
            final nameLower = teacher.name.toLowerCase();
            final subjectsLower = teacher.subjects.join(',').toLowerCase();
            return nameLower.contains(query) || subjectsLower.contains(query);
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Rechercher par nom ou matière',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                filteredTeachers.isEmpty
                    ? const Center(child: Text('Aucun enseignant trouvé'))
                    : ListView.builder(
                      itemCount: filteredTeachers.length,
                      itemBuilder: (context, index) {
                        final teacher = filteredTeachers[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              teacher.profileImageUrl ?? '',
                            ),
                            backgroundColor: Colors.grey.shade300,
                          ),
                          title: Text(teacher.name),
                          subtitle: Text(teacher.subjects.join(', ')),
                          onTap: () {
                            // TODO : action clic enseignant
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
