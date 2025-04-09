part of 'student_list_cubit.dart';

@immutable
sealed class StudentListState extends Equatable {
  const StudentListState();

  @override
  List<Object> get props => [];
}

final class StudentListInitial extends StudentListState {}

final class StudentListLoading extends StudentListState {}

final class StudentListLoaded extends StudentListState {
  final List<ChildEntity> students;

  const StudentListLoaded(this.students);
  @override
  // TODO: implement props
  List<Object> get props => [students];
}

class StudentLoadFailure extends StudentListState {
  final String message;

  const StudentLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
