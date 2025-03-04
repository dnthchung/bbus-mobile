import 'package:bbus_mobile/features/child_feature.dart/domain/entities/daily_schedule.dart';
import 'package:bbus_mobile/features/child_feature.dart/widgets/timeline_point.dart';
import 'package:flutter/material.dart';

final trackingSchedule = DailyScheduleEntity(
  id: 2,
  date: "2025-03-02",
  pickup: EventDetail(time: "07:30", address: "456 Oak Street, Springfield"),
  attendance: EventDetail(time: '7:45', address: "Springfield High School"),
  drop: EventDetail(time: null, address: "456 Oak Street, Springfield"),
);

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          TimelinePoint(
            icon: Icons.location_pin,
            time: trackingSchedule.pickup?.time,
            title: 'Pick Up',
            address: trackingSchedule.pickup?.address ?? 'N/A',
            isLast: false,
            reachedNext: trackingSchedule.attendance?.time != null,
          ),
          TimelinePoint(
            icon: Icons.apartment,
            time: trackingSchedule.attendance?.time,
            title: 'Attend School',
            address: trackingSchedule.attendance?.address ?? 'N/A',
            isLast: false,
            reachedNext: trackingSchedule.drop?.time != null,
          ),
          TimelinePoint(
            icon: Icons.location_pin,
            time: trackingSchedule.drop?.time,
            title: 'Drop',
            address: trackingSchedule.drop?.address ?? 'N/A',
            isLast: true,
          ),
        ],
      ),
    );
  }
}
