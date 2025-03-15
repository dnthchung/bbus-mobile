part of 'student_list_cubit.dart';

@immutable
sealed class StudentListState extends Equatable {
  const StudentListState();

  @override
  List<Object> get props => [];
}

final class StudentListInitial extends StudentListState {}

final class StudentListLoaded extends StudentListState {
  final int selectedTabIndex;
  final PickupDrop pickupDrop;
  final List<Map<String, String>> filteredStudents;

  const StudentListLoaded({
    required this.selectedTabIndex,
    required this.pickupDrop,
    required this.filteredStudents,
  });

  StudentListLoaded copyWith({
    int? selectedTabIndex,
    PickupDrop? pickupDrop,
    List<Map<String, String>>? filteredStudents,
  }) {
    return StudentListLoaded(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      pickupDrop: pickupDrop ?? this.pickupDrop,
      filteredStudents: filteredStudents ?? this.filteredStudents,
    );
  }

  @override
  List<Object> get props => [selectedTabIndex, pickupDrop, filteredStudents];
}
