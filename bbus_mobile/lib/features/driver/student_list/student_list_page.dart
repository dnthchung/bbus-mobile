import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/get_bus_schedule.dart';
import 'package:bbus_mobile/features/driver/student_list/cubit/student_list_cubit.dart';
import 'package:bbus_mobile/features/driver/student_list/widgets/pickup_drop_toggle.dart';
import 'package:bbus_mobile/features/driver/student_list/widgets/student_expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _busId;
  bool _isBusIdReady = false;
  bool _noSchedule = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    initialize();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initialize() async {
    final res = await sl<GetBusSchedule>().call(NoParams());
    res.fold(
      (l) {
        if (l is EmptyFailure) {
          setState(() {
            _noSchedule = true;
          });
        }
      },
      (r) {
        _noSchedule = false;
        _busId = r.busId!;
        context.read<StudentListCubit>().initialize(_busId);
        context.read<StudentListCubit>().loadStudents(0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_noSchedule) {
      return Center(child: Text('Không có lịch trình hôm nay'));
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PickupDropToggle(),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(
                  Icons.near_me,
                  color: Colors.white,
                ),
                label: const Text('Tuyến đường'),
              ),
            ],
          ),
          TabBar(
            controller: _tabController,
            onTap: (index) => context
                .read<StudentListCubit>()
                .filterByStatus(index.toString()),
            indicatorColor: TColors.primary,
            labelColor: TColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Tất cả'),
              Tab(text: 'Đã đón'),
              Tab(text: 'Chưa đón'),
            ],
          ),
          Expanded(
            child: BlocBuilder<StudentListCubit, StudentListState>(
              builder: (context, state) {
                if (state is StudentListLoaded) {
                  final studentList = state.filteredStudents;
                  return ListView.builder(
                    key: ValueKey(
                        studentList), // Forces rebuild when filter changes
                    itemCount: studentList.length,
                    itemBuilder: (context, index) {
                      final student = studentList[index];

                      return StudentExpandableCard(
                        key: ValueKey(student.studentId),
                        student: student,
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Kết thúc chuyến xe'))
        ],
      ),
    );
  }
}
