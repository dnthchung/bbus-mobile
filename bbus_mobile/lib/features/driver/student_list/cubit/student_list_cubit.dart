import 'dart:async';

import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/get_student_stream.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'student_list_state.dart';

class StudentListCubit extends Cubit<StudentListState> {
  final GetStudentStream _getStudentStream;
  StreamSubscription<List<StudentEntity>>? _subscription;
  List<StudentEntity> _allStudents = [];
  String? _currentFilter;
  int? _currentDirection;
  String? _busId;
  StudentListCubit(this._getStudentStream) : super(StudentListInitial());
  void initialize(String busId) {
    _busId = busId;
  }

  Future<void> markStudentAttendance() async {}
  Future<void> loadStudents(int direction) async {
    final currentState = state;
    _currentDirection = direction;
    if (currentState is StudentListLoaded &&
        currentState.currentDirection == direction) {
      return; // already showing this direction
    }
    emit(StudentListLoading());
    await _subscription?.cancel();
    final result =
        await _getStudentStream(StudentStreamParams(_busId!, direction));
    result.fold(
      (failure) => emit(StudentLoadFailure(failure.message)),
      (stream) {
        _subscription = stream.listen(
          (studentList) {
            _allStudents = studentList;
            _applyFilter();
          },
          onError: (e) => emit(StudentLoadFailure(e.toString())),
        );
      },
    );
  }

  void filterByStatus(String? status) {
    if (status == '1') {
      _currentFilter = 'in bus';
    } else if (status == '2') {
      _currentFilter = 'absent';
    } else {
      _currentFilter = null;
    }
    _applyFilter();
  }

  String getCustomStatus(StudentEntity s) {
    if ((s.checkin == null || s.checkin!.isEmpty) &&
        (s.checkout == null || s.checkout!.isEmpty)) {
      return 'absent';
    } else if (s.checkin != null &&
        (s.checkout == null || s.checkout!.isEmpty)) {
      return 'in bus';
    } else {
      return 'drop-off';
    }
  }

  void _applyFilter() {
    if (_currentDirection == null) return;
    final filtered = _currentFilter == null
        ? _allStudents
        : _allStudents
            .where((s) => getCustomStatus(s) == _currentFilter!.toLowerCase())
            .toList();

    emit(StudentListLoaded(
      filteredStudents: filtered,
      allStudents: _allStudents,
      currentDirection: _currentDirection!,
      currentFilter: _currentFilter,
    ));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
