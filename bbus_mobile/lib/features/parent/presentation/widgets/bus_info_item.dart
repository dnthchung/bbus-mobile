import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class BusInfoItem extends StatelessWidget {
  final IconData firstIcon;
  final String middleTitle;
  final String middleInfo;
  final IconData? lastIcon;
  final VoidCallback? onLastIconTap;
  const BusInfoItem(
      {super.key,
      required this.firstIcon,
      required this.middleTitle,
      required this.middleInfo,
      this.lastIcon,
      this.onLastIconTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(),
            alignment: AlignmentDirectional(0, -1),
            child: Icon(
              firstIcon,
              color: TColors.primary,
              size: 24,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            width: 100,
            height: 50,
            decoration: BoxDecoration(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  middleTitle,
                  style: TextStyle(fontSize: 14, color: TColors.textSecondary),
                ),
                Text(
                  middleInfo,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: 50,
            decoration: BoxDecoration(),
            alignment: AlignmentDirectional(0, -1),
            child: lastIcon != null
                ? GestureDetector(
                    onTap: onLastIconTap,
                    child: Icon(
                      lastIcon,
                      color: TColors.primary,
                      size: 24,
                    ),
                  )
                : SizedBox(),
          ),
        ),
      ],
    );
  }
}
