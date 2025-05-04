import 'dart:async';

import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/common/entities/student.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/end_schedule.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/get_bus_schedule.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/get_student_stream.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/mark_attendance.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'student_list_state.dart';

class StudentListCubit extends Cubit<StudentListState> {
  final GetStudentStream _getStudentStream;
  final MarkAttendance _markAttendance;
  final EndSchedule _endSchedule;
  StreamSubscription<List<StudentEntity>>? _subscription;
  List<StudentEntity> _allStudents = [];
  String? _currentFilter;
  int? _currentDirection;
  BusScheduleEntity? _busSchedule;
  String? _message;
  bool? _routeEnded;
  StudentListCubit(
      this._getStudentStream, this._markAttendance, this._endSchedule)
      : super(StudentListInitial());
  void firstInitial(BusScheduleEntity busSchedule) {
    _busSchedule = busSchedule;
    _routeEnded = busSchedule.busScheduleStatus!.toLowerCase() == 'completed';
  }

  Future<void> initialize(BusScheduleEntity busSchedule) async {
    final res = await sl<GetBusSchedule>().call(NoParams());
    res.fold(
      (l) {
        logger.e(l.message);
      },
      (r) {
        if (r.isNotEmpty) {
          final newBusSchedule =
              r.firstWhere((bs) => bs.direction == busSchedule.direction);
          _busSchedule = newBusSchedule;
          _routeEnded =
              newBusSchedule.busScheduleStatus!.toLowerCase() == 'completed';
        }
      },
    );
  }

  Future<void> markStudentAttendance() async {}
  Future<void> loadStudents(int direction) async {
    // final currentState = state;
    _currentDirection = direction;
    // if (currentState is StudentListLoaded &&
    //     currentState.currentDirection == direction) {
    //   return; // already showing this direction
    // }
    emit(StudentListLoading());
    await _subscription?.cancel();
    final result = await _getStudentStream(
        StudentStreamParams(_busSchedule!.busId!, direction));
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
      allStudents: List<StudentEntity>.from(_allStudents),
      currentDirection: _currentDirection!,
      currentFilter: _currentFilter,
      routeEnded: _routeEnded,
    ));
  }

  Future<void> markAttendance(
      String attendanceId, DateTime? checkin, DateTime? checkout) async {
    final res = await _markAttendance(
        MarkAttendanceParams(attendanceId, checkin, checkout));
    res.fold((l) {
      final currentState = state;
      if (currentState is StudentListLoaded) {
        emit(currentState.copyWith(message: l.message));
      }
    }, (r) {
      final index = _allStudents.indexWhere((s) => s.id == attendanceId);
      if (index != -1) {
        final updatedStudent = _allStudents[index].copyWith(
          checkin: checkin?.toIso8601String(),
          checkout: checkout?.toIso8601String(),
        );
        _allStudents[index] = updatedStudent;
        _applyFilter(); // Refresh UI with updated data
      }
    });
  }

  Future<void> endRoute(String feedback) async {
    if (state is StudentListLoaded) {
      final currentState = state as StudentListLoaded;
      final res = await _endSchedule
          .call(EndScheduleParams(_busSchedule!.id!, feedback));
      res.fold((l) {
        emit(currentState.copyWith(message: l.message));
      }, (r) {
        _routeEnded = true;
        emit(currentState.copyWith(
            routeEnded: true,
            message: 'Xác nhận kết thúc chuyến xe thành công'));
      });
      emit(currentState.copyWith(routeEnded: true));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
