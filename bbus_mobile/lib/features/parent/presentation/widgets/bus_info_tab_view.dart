import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/bus_info_item.dart';
import 'package:flutter/material.dart';

List<(String, String, String, String, String)> busInfoList = [];

class BusInfoTabView extends StatelessWidget {
  final BusEntity busDetail;
  const BusInfoTabView({super.key, required this.busDetail});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(12, 24, 12, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        spacing: 28,
        children: [
          BusInfoItem(
              firstIcon: Icons.airline_seat_recline_normal_rounded,
              middleTitle: 'Tài xế',
              middleInfo: busDetail.driverName),
          BusInfoItem(
              firstIcon: Icons.directions_bus,
              middleTitle: 'Số hiệu',
              middleInfo: busDetail.espId),
          BusInfoItem(
              firstIcon: Icons.info,
              middleTitle: 'Biển số xe',
              middleInfo: busDetail.licensePlate),
          BusInfoItem(
            firstIcon: Icons.account_box_rounded,
            middleTitle: 'Phụ xe',
            middleInfo: busDetail.assistantName,
            lastIcon: Icons.call,
          ),
          BusInfoItem(
            firstIcon: Icons.location_city,
            middleTitle: 'Liên hệ trường',
            middleInfo: '+1 987 654 4310',
            lastIcon: Icons.call,
          ),
        ],
      ),
    );
  }
}
