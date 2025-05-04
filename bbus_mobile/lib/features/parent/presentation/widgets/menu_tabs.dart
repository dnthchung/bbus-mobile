import 'dart:async';

import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/common/notifications/notification_service.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/errors/exceptions.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/map/cubit/location_tracking/location_tracking_cubit.dart';
import 'package:bbus_mobile/features/parent/data/datasources/children_datasource.dart';
import 'package:bbus_mobile/features/parent/domain/entities/daily_schedule.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/bus_info_tab_view.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/status_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuTabs extends StatefulWidget {
  final String childId;
  final ScrollController scrollController;
  final List<CheckpointEntity> checkpoints;
  const MenuTabs(
      {super.key,
      required this.childId,
      required this.checkpoints,
      required this.scrollController});

  @override
  State<MenuTabs> createState() => _MenuTabsState();
}

class _MenuTabsState extends State<MenuTabs> with TickerProviderStateMixin {
  TabController? _tabController;
  StreamSubscription<dynamic>? _notifSubscription;
  DailyScheduleEntity? _trackingSchedule;
  bool _isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _init();
  }

  void _init() async {
    try {
      final res =
          await sl<ChildrenDatasource>().getChildAttendance(widget.childId);
      setState(() {
        _trackingSchedule = DailyScheduleEntity(
          pickup: EventDetail.withFormattedTime(
              time: res[0].checkin, address: res[0].checkpointName),
          attendance: EventDetail.withFormattedTime(
              time: res[0].checkout,
              timeLeave: res[1].checkin,
              address: "Trường tiểu học Ngôi Sao"),
          drop: EventDetail.withFormattedTime(
              time: res[1].checkout, address: res[1].checkpointName),
        );
        _isLoading = false;
      });
      final _notifService = sl<NotificationService>();
      _notifSubscription = _notifService.notificationStream.listen((message) {
        logger.i('new message');
        setState(() {
          if (message['direction'] == 'PICK_UP' &&
              message['status'] == 'IN_BUS') {
            _trackingSchedule = _trackingSchedule!.copyWith(
                pickup:
                    _trackingSchedule!.pickup!.copyWith(time: message['time']));
          } else if (message['direction'] == 'PICK_UP' &&
              message['status'] == 'ATTENDED') {
            _trackingSchedule = _trackingSchedule!.copyWith(
                attendance: _trackingSchedule!.attendance!
                    .copyWith(time: message['time']));
          } else if (message['direction'] == 'DROP_OFF' &&
              message['status'] == 'IN_BUS') {
            _trackingSchedule = _trackingSchedule!.copyWith(
                attendance: _trackingSchedule!.attendance!
                    .copyWith(timeLeave: message['time']));
          } else if (message['direction'] == 'DROP_OFF' &&
              message['status'] == 'ATTENDED') {
            _trackingSchedule = _trackingSchedule!.copyWith(
                drop: _trackingSchedule!.drop!.copyWith(time: message['time']));
          }
        });
      });
    } on EmptyException catch (e) {
      setState(() {
        _isLoading = false;
      });
      logger.e(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không có lịch chạy xe cho ngày hôm nay'),
          duration: const Duration(seconds: 2),
        ),
      );
    } on ServerException catch (e) {
      setState(() {
        _isLoading = false;
      });
      logger.e(e.toString());
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Lỗi không xác định'),
      //     duration: const Duration(seconds: 2),
      //   ),
      // );
    } catch (e) {
      logger.e(e.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    _notifSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final busDetail = context.watch<LocationTrackingCubit>().busDetail;

    if (busDetail == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tab bar stays pinned
          TabBar(
            labelColor: TColors.primary,
            unselectedLabelColor: TColors.textSecondary,
            labelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            indicatorColor: TColors.primary,
            controller: _tabController,
            tabs: const [
              Tab(text: 'Trạng thái'),
              Tab(text: 'Thông tin xe'),
            ],
          ),

          // Scrollable content under the TabBar
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Wrap with SingleChildScrollView or your desired scrollable
                SingleChildScrollView(
                  controller: widget.scrollController,
                  padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                  child: StatusTabView(
                    trackingSchedule: _trackingSchedule,
                    isLoading: _isLoading,
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 24, 12, 12),
                  controller: widget.scrollController,
                  child: BusInfoTabView(
                    busDetail: busDetail,
                    checkpoints: widget.checkpoints,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
