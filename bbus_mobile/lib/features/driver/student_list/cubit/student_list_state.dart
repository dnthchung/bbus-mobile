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
  final int currentDirection;

  const StudentListLoaded({
    required this.filteredStudents,
    required this.allStudents,
    required this.currentDirection,
    this.currentFilter,
  });

  @override
  List<Object?> get props =>
      [filteredStudents, currentDirection, currentFilter];
}

class StudentLoadFailure extends StudentListState {
  final String message;

  const StudentLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
