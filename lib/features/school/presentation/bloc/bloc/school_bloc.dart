import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leloprof/features/school/domain/models/school_model.dart';
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
      print('Schools loaded: ${schools.length}');
      if (schools.isEmpty) {
        print('No schools found but no error');
      }
      emit(SchoolLoaded(schools));
    } catch (e) {
      print('Error loading schools: $e');
      emit(SchoolError("Erreur lors du chargement: ${e.toString()}"));
    }
  }

  Future<void> _onCreateSchool(
    CreateSchool event,
    Emitter<SchoolState> emit,
  ) async {
    try {
      print('>>> Bloc: Création d\'école en cours...');
      emit(SchoolLoading());
      await schoolRepository.createSchool(event.school);
      print('>>> Bloc: Création terminée, chargement des écoles...');
      final schools = await schoolRepository.getSchools();
      print('>>> Bloc: ${schools.length} école(s) trouvée(s).');
      emit(SchoolLoaded(schools));
    } catch (e) {
      print('>>> Bloc: Erreur lors de la création - $e');
      emit(
        SchoolError("Erreur lors de la création de l'école : ${e.toString()}"),
      );
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
}
