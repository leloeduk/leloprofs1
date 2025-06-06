import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leloprof/features/auth/presentation/bloc/bloc/auth_bloc.dart';
import 'package:leloprof/utils/widgets/custom_dropdown_button.dart';
import '../../../../utils/models/listes.dart';
import '../../domain/models/teacher_model.dart';
import '../bloc/bloc/teacher_bloc.dart';
import '../bloc/bloc/teacher_event.dart';
import '../bloc/bloc/teacher_state.dart';

class TeacherSearchPage extends StatefulWidget {
  const TeacherSearchPage({super.key});

  @override
  State<TeacherSearchPage> createState() => _TeacherSearchPageState();
}

class _TeacherSearchPageState extends State<TeacherSearchPage> {
  List<TeacherModel> filteredTeachers = [];
  String query = '';
  List<TeacherModel> _allTeachers = [];
  int? yearsOfExperience;
  List<String> educationCycles = [];
  List<String> diplomas = [];
  String? selectedSubject;
  String? selectedLevel;
  String? selectedDiploma;
  String? selectedCity;
  String? selectedExperience;

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(LoadTeachers());
  }

  void updateSearch() {
    setState(() {
      filteredTeachers =
          _allTeachers.where((teacher) {
            final nameLower = teacher.name.toLowerCase();
            final subjectsLower = teacher.subjects.join(', ').toLowerCase();
            final departmentLower = teacher.department.toLowerCase();
            final queryLower = query.toLowerCase();

            bool matchesQuery =
                query.isEmpty ||
                nameLower.contains(queryLower) ||
                subjectsLower.contains(queryLower) ||
                departmentLower.contains(queryLower);

            bool matchesExperience =
                yearsOfExperience == null ||
                teacher.yearsOfExperience >= yearsOfExperience!;

            bool matchesEducationCycles =
                educationCycles.isEmpty ||
                educationCycles.any(
                  (cycle) => teacher.educationCycles.contains(cycle),
                );

            bool matchesDiplomas =
                diplomas.isEmpty ||
                diplomas.any((diploma) => teacher.diplomas.contains(diploma));

            bool matchesSubject =
                selectedSubject == null ||
                teacher.subjects.contains(selectedSubject);

            bool matchesLevel =
                selectedLevel == null ||
                teacher.educationCycles.contains(selectedLevel);

            bool matchesSelectedDiploma =
                selectedDiploma == null ||
                teacher.diplomas.contains(selectedDiploma);

            bool matchesCity =
                selectedCity == null || teacher.department == selectedCity;

            bool matchesSelectedExperience =
                selectedExperience == null ||
                teacher.yearsOfExperience ==
                    int.tryParse(selectedExperience?.split(' ').first ?? '0');

            return matchesQuery &&
                matchesExperience &&
                matchesEducationCycles &&
                matchesDiplomas &&
                matchesSubject &&
                matchesLevel &&
                matchesSelectedDiploma &&
                matchesCity &&
                matchesSelectedExperience;
          }).toList();
    });
  }

  void clearFilters() {
    setState(() {
      query = '';
      yearsOfExperience = null;
      educationCycles = [];
      diplomas = [];
      selectedSubject = null;
      selectedLevel = null;
      selectedDiploma = null;
      selectedCity = null;
      selectedExperience = null;
      filteredTeachers = List.from(_allTeachers);
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 160,
                        width: double.infinity,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/logos/leloprof.png",
                              height: 80,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              " Faitez recherche sur l'applicaton leloprf",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomDropdownButton(
                        title: 'Matière',
                        listes: ListesApp.subjects,
                        selectedItem: selectedSubject,
                        onChanged: (value) {
                          setState(() {
                            selectedSubject = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownButton(
                        title: 'Niveau',
                        listes: ListesApp.levels,
                        selectedItem: selectedLevel,
                        onChanged: (value) {
                          setState(() {
                            selectedLevel = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownButton(
                        title: 'Diplôme',
                        listes: ListesApp.diplomas,
                        selectedItem: selectedDiploma,
                        onChanged: (value) {
                          setState(() {
                            selectedDiploma = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownButton(
                        title: 'Années d\'expérience',
                        listes: ListesApp.experienceYears,
                        selectedItem: selectedExperience,
                        onChanged: (value) {
                          setState(() {
                            selectedExperience = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      CustomDropdownButton(
                        title: 'Ville',
                        listes: ListesApp.congoCities,
                        selectedItem: selectedCity,
                        onChanged: (value) {
                          setState(() {
                            selectedCity = value;
                          });
                        },
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                yearsOfExperience = int.tryParse(
                                  selectedExperience?.split(' ').first ?? '0',
                                );
                                updateSearch();
                              },
                              child: const Text(
                                'Rechercher',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                              ),
                              onPressed: () {
                                clearFilters();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Effacer les filtres',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TeacherBloc, TeacherState>(
        listener: (context, state) {
          if (state is TeacherLoaded) {
            setState(() {
              _allTeachers = state.teachers;
              filteredTeachers = List.from(_allTeachers);
            });
          } else if (state is TeacherError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Erreur: ${state.message}')));
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 6,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (input) {
                          query = input;
                          updateSearch();
                        },
                        decoration: InputDecoration(
                          hintText: 'Nom, matière, département...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.all(2),
                      child: IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          size: 24,
                          color: Colors.white,
                        ),
                        onPressed: _showFilterBottomSheet,
                      ),
                    ),
                  ],
                ),
              ),
              if (state is TeacherLoading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is TeacherLoaded ||
                  filteredTeachers.isNotEmpty ||
                  query.isNotEmpty)
                Expanded(
                  child:
                      filteredTeachers.isEmpty
                          ? Center(
                            child: Text(
                              query.isEmpty
                                  ? 'Aucun enseignant à afficher.'
                                  : 'Aucun enseignant trouvé pour "$query"',
                            ),
                          )
                          : ListView.builder(
                            itemCount: filteredTeachers.length,
                            itemBuilder: (context, index) {
                              final teacher = filteredTeachers[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                elevation: 1,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        teacher.profileImageUrl != null &&
                                                teacher
                                                    .profileImageUrl!
                                                    .isNotEmpty
                                            ? NetworkImage(
                                              teacher.profileImageUrl!,
                                            )
                                            : null,
                                    backgroundColor: Colors.red.shade100,
                                    child:
                                        teacher.profileImageUrl == null ||
                                                teacher.profileImageUrl!.isEmpty
                                            ? Text(
                                              teacher.name.isNotEmpty
                                                  ? teacher.name[0]
                                                      .toUpperCase()
                                                  : 'P',
                                              style: TextStyle(
                                                color: Colors.red.shade700,
                                              ),
                                            )
                                            : null,
                                  ),
                                  title: Text(
                                    teacher.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${teacher.subjects.join(', ')}\n${teacher.department}',
                                  ),
                                  isThreeLine: true,
                                  onTap: () {
                                    final currentUserId =
                                        context
                                            .read<AuthBloc>()
                                            .authRepository
                                            .getCurrentUser()!
                                            .id;
                                    context.pushNamed(
                                      'teacher-details',
                                      pathParameters: {'id': teacher.id},
                                      extra: teacher,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                )
              else if (state is TeacherError)
                Expanded(child: Center(child: Text('Erreur: ${state.message}')))
              else
                const Expanded(
                  child: Center(
                    child: Text('Commencez par rechercher un enseignant.'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
