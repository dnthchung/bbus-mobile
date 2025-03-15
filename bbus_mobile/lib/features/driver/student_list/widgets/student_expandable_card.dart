import 'package:bbus_mobile/common/widgets/child_card.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class StudentExpandableCard extends StatefulWidget {
  final String name;
  final String age;
  final String address;
  final String status;
  final String? avatar;
  final String parentName;
  final String parentPhone;

  const StudentExpandableCard({
    Key? key,
    required this.name,
    required this.age,
    required this.address,
    required this.status,
    this.avatar,
    required this.parentName,
    required this.parentPhone,
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
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpand,
            child: ChildCard(
              name: widget.name,
              age: widget.age,
              address: widget.address,
              status: widget.status,
              avatar: widget.avatar,
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
