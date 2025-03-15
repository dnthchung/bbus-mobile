import 'package:bbus_mobile/features/child_feature.dart/bus_info/bus_info_item.dart';
import 'package:flutter/material.dart';

List<(String, String, String, String, String)> busInfoList = [];

class BusInfoPage extends StatelessWidget {
  const BusInfoPage({super.key});

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
              middleTitle: 'Driver Name',
              middleInfo: 'David Hood'),
          BusInfoItem(
              firstIcon: Icons.directions_bus,
              middleTitle: 'Bus Number',
              middleInfo: '46269-BA'),
          BusInfoItem(
              firstIcon: Icons.info,
              middleTitle: 'Lience Number',
              middleInfo: 'BS5231-5321'),
          BusInfoItem(
            firstIcon: Icons.account_box_rounded,
            middleTitle: 'Helper Name',
            middleInfo: 'Michael Hopson',
            lastIcon: Icons.call,
          ),
          BusInfoItem(
            firstIcon: Icons.location_city,
            middleTitle: 'School Contact',
            middleInfo: '+1 987 654 4310',
            lastIcon: Icons.call,
          ),
        ],
      ),
    );
  }
}
