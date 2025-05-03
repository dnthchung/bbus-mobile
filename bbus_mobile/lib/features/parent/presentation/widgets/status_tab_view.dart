import 'package:bbus_mobile/features/parent/domain/entities/daily_schedule.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/timeline_point.dart';
import 'package:flutter/material.dart';

class StatusTabView extends StatelessWidget {
  final DailyScheduleEntity? trackingSchedule;
  final bool isLoading;
  const StatusTabView(
      {super.key, this.trackingSchedule, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return (isLoading)
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (trackingSchedule != null)
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
                    title: 'Trường liên cấp TH & THCS Ngôi sao Hà nội',
                    timeLeave: trackingSchedule!.attendance?.timeLeave,
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
                  'Không có lịch trình cho ngày hôm nay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              );
  }
}
