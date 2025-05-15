import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/domain/school_repository.dart';
import 'school_event.dart';
import 'school_state.dart';

class SchoolBloc extends Bloc<SchoolEvent, SchoolState> {
  final SchoolRepository repository;

  SchoolBloc({required this.repository}) : super(SchoolInitial()) {
    on<LoadSchools>(_onLoadSchools);
    on<CreateSchool>(_onCreateSchool);
    on<UpdateSchool>(_onUpdateSchool);
    on<DeleteSchool>(_onDeleteSchool);
    on<UpdateSchoolPlan>(_onUpdateSchoolPlan);
  }

  Future<void> _onLoadSchools(
    LoadSchools event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    try {
      final schools = await repository.getSchools();
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
      await repository.createSchool(event.school);
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
      await repository.updateSchool(event.school);
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
      await repository.deleteSchool(event.id);
      add(LoadSchools());
    } catch (e) {
      emit(SchoolError("Erreur lors de la suppression de l'école"));
    }
  }

  Future<void> _onUpdateSchoolPlan(
    UpdateSchoolPlan event,
    Emitter<SchoolState> emit,
  ) async {
    emit(SchoolLoading());
    try {
      await repository.updateSchoolPlan(event.schoolId, event.newPlan);
      final schools = await repository.getSchools();
      emit(SchoolLoaded(schools)); // on émet la liste mise à jour
      // ou si tu préfères juste indiquer la réussite :
      // emit(SchoolPlanUpdated());
    } catch (e) {
      emit(
        SchoolError('Erreur lors de la mise à jour du plan: ${e.toString()}'),
      );
    }
  }
}
