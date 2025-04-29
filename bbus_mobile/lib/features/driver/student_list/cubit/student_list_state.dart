part of 'student_list_cubit.dart';

@immutable
sealed class StudentListState extends Equatable {
  const StudentListState();

  @override
  List<Object?> get props => [];
}

final class StudentListInitial extends StudentListState {}

final class StudentListLoading extends StudentListState {}

class StudentListLoaded extends StudentListState {
  final List<StudentEntity> filteredStudents;
  final List<StudentEntity> allStudents;
  final String? currentFilter;
  final String? message;
  final bool? routeEnded;
  final int currentDirection;

  const StudentListLoaded({
    required this.filteredStudents,
    required this.allStudents,
    required this.currentDirection,
    this.currentFilter,
    this.message,
    this.routeEnded = false,
  });

  @override
  List<Object?> get props =>
      [filteredStudents, currentDirection, currentFilter, allStudents, message];
  StudentListLoaded copyWith({
    List<StudentEntity>? filteredStudents,
    List<StudentEntity>? allStudents,
    int? currentDirection,
    String? currentFilter,
    String? message,
    bool? routeEnded,
  }) {
    return StudentListLoaded(
      filteredStudents: filteredStudents ?? this.filteredStudents,
      allStudents: allStudents ?? this.allStudents,
      currentDirection: currentDirection ?? this.currentDirection,
      currentFilter: currentFilter ?? this.currentFilter,
      message: message ?? this.message,
      routeEnded: routeEnded ?? this.routeEnded,
    );
  }
}

class StudentLoadFailure extends StudentListState {
  final String message;

  const StudentLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
