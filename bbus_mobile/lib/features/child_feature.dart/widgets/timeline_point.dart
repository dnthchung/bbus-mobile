import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class TimelinePoint extends StatelessWidget {
  final IconData icon;
  final String time;
  final String title;
  final String address;
  final bool isLast;

  const TimelinePoint(
      {super.key,
      required this.icon,
      required this.time,
      required this.title,
      required this.address,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                alignment: AlignmentDirectional(0, 0),
                child: Icon(
                  icon,
                  color: TColors.primary,
                  size: 16,
                ),
              ),
              if (!isLast)
                Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Container(
                    width: 1,
                    height: 60,
                    decoration: BoxDecoration(
                      color: TColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Text(
                  time,
                  style: TextStyle(fontSize: 16, color: TColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: TColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
