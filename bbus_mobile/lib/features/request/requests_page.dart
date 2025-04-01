import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class RequestsPage extends StatelessWidget {
  final List<Map<String, dynamic>> requestTypes = [
    {
      'type': 'Chọn điểm đón',
      'icon': Icons.edit_location_alt,
      'path': RouteNames.parentEditLocation
    },
    {
      'type': 'Thêm điểm đón',
      'icon': Icons.add_location_alt,
      'path': RouteNames.parentEditLocation
    },
    {'type': 'Báo vắng', 'icon': Icons.event_busy},
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: Request Type Selection
          Text(
            'Chọn loại yêu cầu',
            style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: TColors.darkPrimary),
          ),
          Wrap(
            spacing: 10,
            children: requestTypes.map((request) {
              return GestureDetector(
                onTap: () {
                  context.pushNamed(request['path']);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: TColors.accent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(request['icon'], size: 40, color: Colors.white),
                      SizedBox(height: 5),
                      Text(
                        request['type'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          // Bottom section: Request History
          Text(
            'Danh sách yêu cầu đã gửi',
            style: TextStyle(
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: TColors.darkPrimary),
          ),
          Expanded(child: RequestList()),
        ],
      ),
    );
  }
}

class RequestList extends StatefulWidget {
  const RequestList({super.key});

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  final List<Map<String, String>> requestHistory = [
    {
      'type': 'Leave',
      'typeName': 'Sửa điểm đón',
      'status': 'Approved',
      'content':
          'Điểm đón được sửa thành Nhân Chính, Thanh Xuân, Hà Nội, Việt Nam',
      'createdAt': '22/02/2025'
    },
    {
      'type': 'Expense',
      'typeName': 'Báo nghỉ',
      'status': 'Pending',
      'content':
          'Đơn xin báo nghỉ: do bé có lịch khám riêng nên bé sẽ không đi xe buýt ngày 12/03/2025',
      'createdAt': '22/02/2025'
    },
  ];
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  String? selectedType;
  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredHistory = requestHistory.where((request) {
      return selectedType == null || request['type'] == selectedType;
    }).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  hint: const Text('Filter by Type',
                      style: TextStyle(fontSize: 16)),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                  items: [
                    {'type': null, 'typeName': 'Tất cả'}, // 'All' option
                    ...requestHistory
                  ].map((entry) {
                    return DropdownMenuItem(
                      value: entry['type'], // Keep the actual value as 'type'
                      child: Text(
                        entry['typeName'] ?? '',
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredHistory.length,
            itemBuilder: (context, index) {
              final request = filteredHistory[index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              request['typeName'] ?? 'No Type Name',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            decoration: BoxDecoration(
                              color: _getStatusColor(request['status']!)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              request['status']!,
                              style: TextStyle(
                                color: _getStatusColor(request['status']!),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(request['content'] ?? 'No content'),
                      const SizedBox(height: 5),
                      Text('Created: ${request['createdAt']}',
                          style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
