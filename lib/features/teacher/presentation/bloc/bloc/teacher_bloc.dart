import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'teacher_event.dart';
import 'teacher_state.dart';
import '../../../domain/repositories/teacher_repository.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  final TeacherRepository teacherRepository;

  TeacherBloc({required this.teacherRepository}) : super(TeacherInitial()) {
    on<LoadTeachers>(_onLoadTeachers);
    on<CreateTeacher>(_onCreateTeacher);
    on<UpdateTeacher>(_onUpdateTeacher);
    on<DeleteTeacher>(_onDeleteTeacher);
    on<SearchTeachers>(_onSearchTeachers);
    // on<UpdateTeacherPlan>(_onUpdateTeacherPlan);
  }

  Future<void> _onLoadTeachers(
    LoadTeachers event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    try {
      final teachers = await teacherRepository.fetchAllTeachers();
      print(teachers);
      emit(TeacherLoaded(teachers));
    } catch (e) {
      emit(
        TeacherError(
          'Erreur lors du chargement des enseignants: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onCreateTeacher(
    CreateTeacher event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    try {
      await teacherRepository.createTeacher(event.teacher);
      final teachers = await teacherRepository.fetchAllTeachers();
      emit(TeacherLoaded(teachers));
    } catch (e) {
      emit(
        TeacherError(
          'Erreur lors de la création de l\'enseignant: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onUpdateTeacher(
    UpdateTeacher event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    try {
      await teacherRepository.updateTeacher(event.teacher);
      final teachers = await teacherRepository.fetchAllTeachers();
      emit(TeacherLoaded(teachers));
    } catch (e) {
      emit(
        TeacherError(
          'Erreur lors de la mise à jour de l\'enseignant: ${e.toString()}',
        ),
      );
    }
  }

  Future<void> _onDeleteTeacher(
    DeleteTeacher event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    try {
      await teacherRepository.deleteTeacher(event.id);
      final teachers = await teacherRepository.fetchAllTeachers();
      emit(TeacherLoaded(teachers));
    } catch (e) {
      emit(
        TeacherError(
          'Erreur lors de la suppression de l\'enseignant: ${e.toString()}',
        ),
      );
    }
  }

  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> _onSearchTeachers(
    SearchTeachers event,
    Emitter<TeacherState> emit,
  ) async {
    emit(TeacherLoading());
    try {
      final teachers = await teacherRepository.searchTeachers(
        name: event.name,
        department: event.department,
        country: event.country,
        district: event.district,
        subjects: event.subjects,
        languages: event.languages,
        isAvailable: event.isAvailable,
        isCivilServant: event.isCivilServant,
        isInspector: event.isInspector,
      );
      emit(TeacherSearchLoaded(teachers));
    } catch (e) {
      emit(
        TeacherError(
          "Erreur lors de la recherche des enseignants: ${e.toString()}",
        ),
      );
    }
  }
}
