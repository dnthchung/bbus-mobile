import 'dart:math';

import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/errors/failures.dart';
import 'package:bbus_mobile/core/usecases/usecase.dart';
import 'package:bbus_mobile/features/driver/domain/usecases/get_bus_schedule.dart';
import 'package:bbus_mobile/features/driver/student_list/cubit/student_list_cubit.dart';
import 'package:bbus_mobile/features/driver/student_list/widgets/end_route_form.dart';
import 'package:bbus_mobile/features/driver/student_list/widgets/pickup_drop_toggle.dart';
import 'package:bbus_mobile/features/driver/student_list/widgets/student_expandable_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<BusScheduleEntity> _busSchedules;
  bool _isLoading = true;
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
        print('Error: ${l.message}');
        if (l is EmptyFailure) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Một số lỗi đã xảy ra, vui lòng thử lại sau'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      (r) {
        if (r.isNotEmpty) {
          _noSchedule = false;
          _busSchedules = r;
          context.read<StudentListCubit>().initialize(_busSchedules.last);
          context.read<StudentListCubit>().loadStudents(0);
        } else {
          _noSchedule = true;
        }
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
              PickupDropToggle(
                busSchedules: _busSchedules,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.pushNamed(RouteNames.driverBusMap, pathParameters: {
                    'routeId': _busSchedules.first.routeId.toString(),
                  });
                },
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
            child: BlocConsumer<StudentListCubit, StudentListState>(
              listener: (context, state) {
                if (state is StudentListLoaded) {
                  if (state.message != null && state.message!.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${state.message}')),
                    );
                  }
                }
              },
              builder: (context, state) {
                if (state is StudentListLoaded) {
                  final studentList = state.filteredStudents;
                  final isEndRoute = !state.allStudents
                      .any((s) => (s.checkout == null && s.checkin != null));
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          key: ValueKey(studentList),
                          itemCount: studentList.length,
                          itemBuilder: (context, index) {
                            final student = studentList[index];
                            return StudentExpandableCard(
                              routeEnded: state.routeEnded ?? false,
                              key: ValueKey(
                                  '${student.studentId}-${student.checkin}-${student.checkout}'),
                              student: student,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      (state.routeEnded ?? false)
                          ? Text(
                              'Chuyến xe đã kết thúc',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: isEndRoute
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => EndRouteModal(
                                          onSubmit: (feedback) {
                                            context
                                                .read<StudentListCubit>()
                                                .endRoute(feedback);
                                          },
                                          onCancel: () {},
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text('Kết thúc chuyến xe'),
                            )
                    ],
                  );
                } else if (state is StudentLoadFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                } else if (state is StudentListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
