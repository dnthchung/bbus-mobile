import 'package:bbus_mobile/common/widgets/child_card.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/utils/date_utils.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/parent/data/datasources/children_datasource.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ChildrenListPage extends StatefulWidget {
  const ChildrenListPage({super.key});

  @override
  State<ChildrenListPage> createState() => _ChildrenListPageState();
}

class _ChildrenListPageState extends State<ChildrenListPage> {
  bool _isLoading = true;
  bool _isEventOpened = false;
  dynamic _registetionEvent;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _geEventTime();
    context.read<ChildrenListCubit>().getAll();
  }

  Future<void> _geEventTime() async {
    try {
      final res = await sl<ChildrenDatasource>().getRegistrationTime();
      if (res is String && res.isEmpty) {
      } else {
        final isWithin =
            isNowBetween(parseAsLocal(res['start']), parseAsLocal(res['end']));
        print(isWithin);
        setState(() {
          _registetionEvent = res;
        });
        if (isWithin != _isEventOpened) {
          setState(() {
            _isEventOpened = isWithin;
          });
        }
      }
    } catch (e) {
      logger.e(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Một số lỗi đã xảy ra, vui lòng thử lại sau')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<ChildrenListCubit, ChildrenListState>(
        builder: (context, state) {
          if (state is ChildrenListSuccess) {
            return Column(
              children: [
                if (_isEventOpened) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Thời gian đăng ký điểm đón đang mở từ ngày ${formatStringDate(_registetionEvent?['start'])} đến ${formatStringDate(_registetionEvent?['end'])}.',
                        style: TextStyle(
                            color: TColors.secondary,
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic),
                      ),
                      SizedBox(
                          width: 8), // Small spacing between text and button
                      ElevatedButton(
                        onPressed: () {
                          context.pushNamed(RouteNames.parentEditLocation,
                              pathParameters: {'actionType': 'register'},
                              extra: state.data.first.checkpointId);
                        },
                        child: Text('Đăng ký'), // Example button text
                      ),
                    ],
                  )
                ] else ...[
                  // Align(
                  //   alignment: Alignment.topLeft,
                  //   child: Text(
                  //     'Thời gian đăng ký điểm đón đã đóng lúc ${formatStringDate(_registetionEvent?['end'])}',
                  //     style: TextStyle(
                  //         color: TColors.textSecondary,
                  //         fontSize: 16.0,
                  //         fontStyle: FontStyle.italic),
                  //   ),
                  // ),
                ],
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await _geEventTime(); // Refresh event data (like openEvent)
                      context
                          .read<ChildrenListCubit>()
                          .getAll(); // Refresh children list
                    },
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        final child = state.data[index];
                        return ChildCard(
                          studentId: child.id ?? 'N/A',
                          busId: child.busId ?? 'Unknown',
                          name: child.name ?? 'No Name',
                          dob: child.dob ?? 'No Age Info',
                          gender: child.gender,
                          avatar: child.avatar ?? '',
                          address: child.address ?? '',
                          checkpointId: child.checkpointId ?? '',
                          checkpointName: child.checkpointName ?? '',
                          status: child.status ?? 'Unknown',
                          isRegisterOpened: _isEventOpened,
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          } else if (state is ChildrenListFailure) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is ChildrenListLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
