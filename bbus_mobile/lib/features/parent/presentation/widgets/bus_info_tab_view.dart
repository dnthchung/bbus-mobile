import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/bus_info_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

List<(String, String, String, String, String)> busInfoList = [];

class BusInfoTabView extends StatelessWidget {
  final BusEntity busDetail;
  const BusInfoTabView({super.key, required this.busDetail});
  void _callNumber(BuildContext context, String phoneNumber) async {
    // Handle phone call logic
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch phone dialer')),
      );
    }
  }

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
              middleInfo: busDetail.driverName ?? 'N/A'),
          BusInfoItem(
              firstIcon: Icons.info_rounded,
              middleTitle: 'Số hiệu',
              middleInfo: busDetail.name ?? 'N/A'),
          BusInfoItem(
              firstIcon: Icons.directions_bus_rounded,
              middleTitle: 'Biển số xe',
              middleInfo: busDetail.licensePlate ?? 'N/A'),
          BusInfoItem(
            firstIcon: Icons.account_box_rounded,
            middleTitle: 'Phụ xe',
            middleInfo: busDetail.assistantName ?? 'N/A',
            lastIcon: (busDetail.assistantPhone != null &&
                    busDetail.assistantPhone!.isNotEmpty)
                ? Icons.call
                : null,
            onLastIconTap: () => _callNumber(context, busDetail.assistantPhone),
          ),
          BusInfoItem(
            firstIcon: Icons.location_city,
            middleTitle: 'Liên hệ trường',
            middleInfo: '1900 8189',
            lastIcon: Icons.call,
            onLastIconTap: () =>
                _callNumber(context, '+19876544310'), // hardcoded for now
          ),
        ],
      ),
    );
  }
}
