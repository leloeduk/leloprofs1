import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/bloc/school_bloc.dart';
import '../bloc/bloc/school_event.dart';
import '../bloc/bloc/school_state.dart';

class SchoolsPage extends StatelessWidget {
  const SchoolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Charger les écoles à l'ouverture de la page
    context.read<SchoolBloc>().add(LoadSchools());

    return Scaffold(
      body: BlocBuilder<SchoolBloc, SchoolState>(
        builder: (context, state) {
          if (state is SchoolLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SchoolError) {
            return Center(child: Text(state.message));
          } else if (state is SchoolLoaded) {
            final schools = state.schools;

            if (schools.isEmpty) {
              return const Center(child: Text("Aucune école trouvée."));
            }

            return ListView.builder(
              itemCount: schools.length,
              itemBuilder: (context, index) {
                final school = schools[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        school.profileImage != null
                            ? NetworkImage(school.profileImage!)
                            : null,
                    child:
                        school.profileImage == null
                            ? const Icon(Icons.school)
                            : null,
                  ),
                  title: Text(school.name),
                  subtitle: Text("${school.town} • ${school.department}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<SchoolBloc>().add(DeleteSchool(school.id));
                    },
                  ),
                  onTap: () {
                    // Tu peux ouvrir ici une page de détails ou un bottom sheet
                  },
                );
              },
            );
          } else {
            return const Center(child: Text("État inconnu."));
          }
        },
      ),
    );
  }
}
