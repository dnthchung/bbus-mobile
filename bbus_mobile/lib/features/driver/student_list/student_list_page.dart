import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
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
  late bool _isAssistant;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<CurrentUserCubit>();
    if (cubit.state is! CurrentUserLoggedIn) {
      context.pushNamed(RouteNames.login);
      return;
    }
    if (cubit.state is CurrentUserLoggedIn) {
      _isAssistant =
          // (cubit.state as CurrentUserLoggedIn).user.role!.toLowerCase() ==
          //     'assistant';
          true;
    }
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
            _noSchedule = true;
            _isLoading = false;
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Một số lỗi đã xảy ra, vui lòng thử lại sau'),
          //     backgroundColor: Colors.red,
          //   ),
          // );
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
                  final studentsCheckedInNotOut = state.allStudents
                      .where((s) => s.checkin != null && s.checkout == null)
                      .toList();
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
                              isAssistant: _isAssistant,
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
                          : (_isAssistant)
                              ? ElevatedButton(
                                  onPressed: () {
                                    if (studentsCheckedInNotOut.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Row(
                                            children: [
                                              const Icon(Icons.warning,
                                                  color: Colors.orange,
                                                  size: 28),
                                              const SizedBox(width: 8),
                                              const Text('Cảnh báo',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          content: SingleChildScrollView(
                                            // wrap content
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Còn học sinh ở trên xe:',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                const SizedBox(height: 12),
                                                ...studentsCheckedInNotOut
                                                    .map(
                                                      (student) => ListTile(
                                                        leading: const Icon(
                                                            Icons.person,
                                                            color: Colors.blue),
                                                        title: Text(student
                                                                .studentName ??
                                                            'Không có tên'),
                                                        subtitle: Text(
                                                            'Mã học sinh: ${student.rollNumber}'),
                                                      ),
                                                    )
                                                    .toList(),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Text('Đã hiểu'),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
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
                                  },
                                  child: Text('Kết thúc chuyến xe'),
                                )
                              : const SizedBox()
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
