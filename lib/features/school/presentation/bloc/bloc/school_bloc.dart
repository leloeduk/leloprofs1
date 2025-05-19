import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/school_repository.dart';
import 'school_event.dart';
import 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository schoolRepository;

  SchoolBloc({required this.schoolRepository}) : super(SchoolInitial()) {
    on<LoadSchools>(_onLoadSchools);
    on<CreateSchool>(_onCreateSchool);
    on<UpdateSchool>(_onUpdateSchool);
    on<DeleteSchool>(_onDeleteSchool);
    on<GetSchoolId>(_onGetSchoolId);
    // on<UpdateSchoolPlan>(_onUpdateSchoolPlan);
  }
  Future<void> _onGetSchoolId(
    GetSchoolId event,
    Emitter<SchoolState> emit,
  ) async {
    try {
      emit(SchoolLoading());
      final school = await schoolRepository.getSchoolById(event.id);
      emit(SchoolIdLoaded(school));
    } catch (e) {
      emit(
        SchoolError(
          "Erreur lors de la récupération de l'école: ${e.toString()}",
        ),
      );
    }
  }

  Future<void> _onLoadSchools(
    LoadSchools event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    try {
      final schools = await schoolRepository.getSchools();
      emit(SchoolLoaded(schools));
    } catch (e) {
      emit(SchoolError("Erreur lors du chargement des écoles"));
    }
  }

  Future<void> _onCreateSchool(
    CreateSchool event,
    Emitter<SchoolState> emit,
  ) async {
    try {
      await schoolRepository.createSchool(event.school);
      add(LoadSchools());
    } catch (e) {
      emit(SchoolError("Erreur lors de la création de l'école"));
    }
  }

  Future<void> _onUpdateSchool(
    UpdateSchool event,
    Emitter<SchoolState> emit,
  ) async {
    try {
      await schoolRepository.updateSchool(event.school);
      add(LoadSchools());
    } catch (e) {
      emit(SchoolError("Erreur lors de la mise à jour de l'école"));
    }
  }

  Future<void> _onDeleteSchool(
    DeleteSchool event,
    Emitter<SchoolState> emit,
  ) async {
    try {
      await schoolRepository.deleteSchool(event.id);
      add(LoadSchools());
    } catch (e) {
      emit(SchoolError("Erreur lors de la suppression de l'école"));
    }
  }

  // Future<void> _onUpdateSchoolPlan(
  //   UpdateSchoolPlan event,
  //   Emitter<SchoolState> emit,
  // ) async {
  //   emit(SchoolLoading());
  //   try {
  //     await schoolRepository.updateSchoolPlan(event.schoolId, event.newPlan);
  //     final schools = await schoolRepository.getSchools();
  //     emit(SchoolLoaded(schools)); // on émet la liste mise à jour
  //     // ou si tu préfères juste indiquer la réussite :
  //     // emit(SchoolPlanUpdated());
  //   } catch (e) {
  //     emit(
  //       SchoolError('Erreur lors de la mise à jour du plan: ${e.toString()}'),
  //     );
  //   }
  // }
}


// // School Handlers
// on<CreateSchoolProfile>((event, emit) async {
//   emit(ProfileLoading());
//   try {
//     await schoolRepository.createSchool(event.school);
//     emit(ProfileOperationSuccess('École créée avec succès'));
//   } catch (e) {
//     emit(ProfileError(e.toString()));
//   }
// });

// on<UpdateSchoolProfile>((event, emit) async {
//   emit(ProfileLoading());
//   try {
//     await schoolRepository.updateSchool(event.school);
//     emit(SchoolProfileLoaded(event.school));
//   } catch (e) {
//     emit(ProfileError(e.toString()));
//   }
// });

// on<DeleteSchoolProfile>((event, emit) async {
//   emit(ProfileLoading());
//   try {
//     await schoolRepository.deleteSchool(event.uid);
//     emit(ProfileOperationSuccess('École supprimée'));
//   } catch (e) {
//     emit(ProfileError(e.toString()));
//   }
// });

// // Teacher Handlers (similaires)