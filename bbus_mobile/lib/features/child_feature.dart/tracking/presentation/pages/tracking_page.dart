import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/child_feature.dart/widgets/timeline_point.dart';
import 'package:flutter/material.dart';

final List<(IconData, String, String, String)> timelineList = [
  (Icons.location_pin, '6: 55', 'Pick up', '123 S Maine Ave, Pine Hills'),
  (Icons.apartment, '7: 30', 'At School', '456 S Maine Ave, Pine Hills'),
  (Icons.location_pin, '4: 30', 'Drop', '123 S Maine Ave, Pine Hills'),
];

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: timelineList.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return TimelinePoint(
            icon: item.$1,
            time: item.$2,
            title: item.$3,
            address: item.$4,
            isLast: index == timelineList.length - 1,
          );
        }).toList(),
      ),
    );
  }
}
