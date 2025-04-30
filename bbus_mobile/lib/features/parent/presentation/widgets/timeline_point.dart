import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class TimelinePoint extends StatelessWidget {
  final IconData icon;
  final String? time;
  final String? timeLeave;
  final String title;
  final String address;
  final bool isLast;
  final String? verifier;
  final bool reachedNext;

  const TimelinePoint(
      {super.key,
      required this.icon,
      this.time,
      required this.title,
      required this.address,
      required this.isLast,
      this.verifier,
      this.reachedNext = true,
      this.timeLeave});

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
                  color: time != null ? TColors.primary : TColors.textSecondary,
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
                      color:
                          reachedNext ? TColors.primary : TColors.textSecondary,
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
                  time ?? 'N/A',
                  style: TextStyle(fontSize: 16, color: TColors.textSecondary),
                ),
              ),
              title == 'Trường tiểu học Ngôi Sao'
                  ? Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: Text(
                        timeLeave ?? 'N/A',
                        style: TextStyle(
                            fontSize: 16, color: TColors.textSecondary),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        Expanded(
          flex: 4,
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
        Expanded(
          flex: 1,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: verifier != null
                ? [
                    Text(
                      'Verifier',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: TColors.textPrimary,
                      ),
                    ),
                    Text(
                      verifier!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: TColors.textSecondary,
                      ),
                    ),
                  ]
                : [SizedBox()],
          ),
        )
      ],
    );
  }
}
