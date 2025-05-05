import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/bus_info_item.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BusInfoTabView extends StatelessWidget {
  final BusEntity busDetail;
  final List<CheckpointEntity> checkpoints;
  const BusInfoTabView(
      {super.key, required this.busDetail, required this.checkpoints});
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        BusInfoItem(
            firstIcon: Icons.airline_seat_recline_normal_rounded,
            middleTitle: 'Tài xế',
            middleInfo: busDetail.driverName ?? 'N/A'),
        SizedBox(
          height: 20,
        ),
        BusInfoItem(
            firstIcon: Icons.info_rounded,
            middleTitle: 'Số hiệu',
            middleInfo: busDetail.name ?? 'N/A'),
        SizedBox(
          height: 20,
        ),
        BusInfoItem(
            firstIcon: Icons.directions_bus_rounded,
            middleTitle: 'Biển số xe',
            middleInfo: busDetail.licensePlate ?? 'N/A'),
        SizedBox(
          height: 20,
        ),
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
        SizedBox(
          height: 20,
        ),
        BusInfoItem(
          firstIcon: Icons.location_city,
          middleTitle: 'Liên hệ trường',
          middleInfo: '1900 8189',
          lastIcon: Icons.call,
          onLastIconTap: () =>
              _callNumber(context, '+19876544310'), // hardcoded for now
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Lộ trình & Thời gian',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        ...checkpoints.map((cp) {
          bool isLast = cp.id == checkpoints.last.id;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              isLast ? Icons.star : Icons.location_on,
              color: isLast ? Colors.amber : Colors.red,
            ),
            title: Text(cp.name!),
            // subtitle: Text("Lat: ${cp.latitude}, Lng: ${cp.longitude}"),
            // trailing: Text(cp.time!),
            subtitle: Text("ƯỚC TÍNH THỜI GIAN ĐÓN/TRẢ: ${cp.time}"),
          );
        }),
      ],
    );
  }
}
