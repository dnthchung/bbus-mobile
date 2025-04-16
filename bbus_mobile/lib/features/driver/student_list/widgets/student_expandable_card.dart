import 'package:bbus_mobile/common/widgets/student_card.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentExpandableCard extends StatefulWidget {
  final String studentId;
  final String name;
  final String age;
  final String address;
  final String status;
  final String? avatar;
  final String parentName;
  final String parentPhone;
  final String checkin;
  final String checkout;

  const StudentExpandableCard({
    Key? key,
    required this.studentId,
    required this.name,
    required this.age,
    required this.address,
    required this.status,
    this.avatar,
    required this.parentName,
    required this.parentPhone,
    required this.checkin,
    required this.checkout,
  }) : super(key: key);

  @override
  _StudentExpandableCardState createState() => _StudentExpandableCardState();
}

class _StudentExpandableCardState extends State<StudentExpandableCard> {
  bool isExpanded = false;

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _callParent() async {
    // Handle phone call logic
    final Uri phoneUri = Uri(scheme: 'tel', path: widget.parentPhone);
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
    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpand,
            child: StudentCard(
              studentId: widget.studentId,
              name: widget.name,
              age: dobStringToAge(widget.age).toString(),
              address: widget.address,
              status: widget.status,
              avatar: widget.avatar,
              checkin: widget.checkin,
              checkout: widget.checkout,
              isParent: false,
            ),
          ),
          if (isExpanded) ...[
            Divider(color: Colors.grey.shade300),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
                    child: Image.asset('assets/images/default_avatar.png',
                        height: 60, width: 60),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.parentName,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 5),
                        Text(widget.parentPhone,
                            style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _callParent,
                    icon: const Icon(Icons.call, color: TColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
