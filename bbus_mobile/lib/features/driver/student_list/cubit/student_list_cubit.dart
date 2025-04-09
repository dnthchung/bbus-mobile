import 'dart:async';

import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/features/driver/domain/repository/student_list_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'student_list_state.dart';

enum PickupDrop { pickup, drop }

class StudentListCubit extends Cubit<StudentListState> {
  final StudentListRepository _repository;
  StreamSubscription<List<ChildEntity>>? _studentSub;
  List<ChildEntity> _allStudents = [];
  String? _currentFilter;
  PickupDrop _pickupDrop = PickupDrop.pickup;
  PickupDrop get pickupDrop => _pickupDrop;

  StudentListCubit(this._repository) : super(StudentListInitial());

  void listenToStudents() {
    emit(StudentListLoading());

    _studentSub?.cancel();
    _studentSub = _repository.getStudentListStream().listen(
      (students) {
        _allStudents = students;
        _applyFilter(); // emit filtered list based on current filter
      },
      onError: (error) {
        emit(StudentLoadFailure("Failed to load students: $error"));
      },
    );
  }

  void filterByStatus(String? status) {
    _currentFilter = status;
    _applyFilter();
  }

  void _applyFilter() {
    final filtered = _currentFilter == null
        ? _allStudents
        : _allStudents.where((s) => s.status == _currentFilter).toList();
    emit(StudentListLoaded(filtered));
  }

  void setPickupDrop(PickupDrop newValue) {
    _pickupDrop = newValue;
    filterByStatus(newValue.name); // or use a mapping
  }

  @override
  Future<void> close() {
    _studentSub?.cancel();
    return super.close();
  }
}
