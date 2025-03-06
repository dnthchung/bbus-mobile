import 'package:bbus_mobile/features/child_feature.dart/domain/entities/daily_schedule.dart';
import 'package:bbus_mobile/features/child_feature.dart/widgets/timeline_point.dart';
import 'package:flutter/material.dart';

class HistoryDetail extends StatelessWidget {
  final DailyScheduleEntity dailySchedule;
  const HistoryDetail({super.key, required this.dailySchedule});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimelinePoint(
          icon: Icons.location_pin,
          time: dailySchedule.pickup?.time,
          title: 'Pick Up',
          address: dailySchedule.pickup?.address ?? 'N/A',
          isLast: false,
        ),
        TimelinePoint(
            icon: Icons.apartment,
            time: dailySchedule.attendance?.time,
            title: 'Attend School',
            address: dailySchedule.attendance?.address ?? 'N/A',
            isLast: false),
        TimelinePoint(
            icon: Icons.location_pin,
            time: dailySchedule.drop?.time,
            title: 'Drop',
            address: dailySchedule.drop?.address ?? 'N/A',
            isLast: true),
      ],
    );
  }
}
