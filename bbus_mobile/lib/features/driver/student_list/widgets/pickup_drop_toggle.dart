import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bbus_mobile/features/driver/student_list/cubit/student_list_cubit.dart';

class PickupDropToggle extends StatelessWidget {
  const PickupDropToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StudentListCubit, StudentListState>(
      builder: (context, state) {
        if (state is! StudentListLoaded) return SizedBox.shrink();
        final cubit = context.read<StudentListCubit>();
        final selected = state.currentDirection;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                label: Text("Đón"),
              ),
              ButtonSegment(
                value: 1,
                label: Text("Trả"),
              ),
            ],
            showSelectedIcon: false,
            selected: {selected},
            onSelectionChanged: (newSelection) {
              cubit.loadStudents(newSelection.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? TColors.accent
                    : Colors.grey[200];
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.black;
              }),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        );
      },
    );
  }
}
