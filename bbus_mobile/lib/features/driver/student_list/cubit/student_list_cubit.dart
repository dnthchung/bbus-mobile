import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'student_list_state.dart';

enum PickupDrop { pickup, drop }

class StudentListCubit extends Cubit<StudentListState> {
  final List<Map<String, String>> allStudents = [
    {
      "name": "Alice Johnson",
      "age": "10",
      "address": "Address1",
      "status": "In Bus",
      "avatar": "null",
      "parentName": "Dave",
      "parentPhone": "0912345672",
    },
    {
      "name": "Bob Johnson",
      "age": "9",
      "address": "Address2",
      "status": "At Home",
      "avatar": "null"
    },
    {
      "name": "Tom Johnson",
      "age": "9",
      "address": "Address3",
      "status": "At School",
      "avatar": "null"
    },
  ];

  StudentListCubit() : super(StudentListInitial()) {
    _filterStudents(0, PickupDrop.pickup);
  }

  void changeTab(int index) {
    if (state is StudentListLoaded) {
      final currentState = state as StudentListLoaded;
      _filterStudents(index, currentState.pickupDrop);
    }
  }

  void togglePickupDrop(PickupDrop newPickupDrop) {
    if (state is StudentListLoaded) {
      final currentState = state as StudentListLoaded;
      _filterStudents(currentState.selectedTabIndex, newPickupDrop);
    }
  }

  void _filterStudents(int tabIndex, PickupDrop pickupDrop) {
    List<Map<String, String>> filtered = allStudents;

    if (tabIndex == 1) {
      filtered = allStudents.where((s) => s["status"] == "In Bus").toList();
    } else if (tabIndex == 2) {
      filtered = allStudents.where((s) => s["status"] == "At School").toList();
    }

    emit(StudentListLoaded(
      selectedTabIndex: tabIndex,
      pickupDrop: pickupDrop,
      filteredStudents: filtered,
    ));
  }
}
