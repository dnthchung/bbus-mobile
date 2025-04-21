import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/features/parent/domain/entities/daily_schedule.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/timeline_point.dart';
import 'package:flutter/material.dart';

class StatusTabView extends StatelessWidget {
  final DailyScheduleEntity? trackingSchedule;
  const StatusTabView({super.key, this.trackingSchedule});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
      child: (trackingSchedule != null)
          ? Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                TimelinePoint(
                  icon: Icons.location_pin,
                  time: trackingSchedule!.pickup?.time,
                  title: 'Lên xe',
                  address: trackingSchedule!.pickup?.address ?? 'N/A',
                  isLast: false,
                  reachedNext: trackingSchedule!.attendance?.time != null,
                ),
                TimelinePoint(
                  icon: Icons.apartment,
                  time: trackingSchedule!.attendance?.time,
                  title: 'Đến trường',
                  address: trackingSchedule!.attendance?.address ?? 'N/A',
                  isLast: false,
                  reachedNext: trackingSchedule!.drop?.time != null,
                ),
                TimelinePoint(
                  icon: Icons.location_pin,
                  time: trackingSchedule!.drop?.time,
                  title: 'Xuống điểm đón',
                  address: trackingSchedule!.drop?.address ?? 'N/A',
                  isLast: true,
                ),
              ],
            )
          : Center(
              child: Text(
                'Chưa có thông tin',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
