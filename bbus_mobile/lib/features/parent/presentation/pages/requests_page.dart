import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/request_list/request_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/request_type/request_type_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/request_type_ui_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RequestsPage extends StatelessWidget {
  List<RequestTypeUIModel> getRequestTypeList() {
    List<RequestTypeUIModel> list = [
      RequestTypeUIModel('changeLocation', 'Chọn điểm đón',
          RouteNames.parentEditLocation, Icons.edit_location_alt),
      RequestTypeUIModel('absent', 'Báo nghỉ', RouteNames.parentAbsentRequest,
          Icons.event_busy),
      RequestTypeUIModel('others', 'Đơn khác', RouteNames.parentOtherRequest,
          Icons.edit_document),
    ];
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UserInfoCard(),
          SizedBox(height: 20),
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
            children: getRequestTypeList().map((request) {
              return GestureDetector(
                onTap: () {
                  if (request.id == 'changeLocation') {
                    print('change location');
                    context.pushNamed(request.pathName,
                        pathParameters: {'actionType': 'change'});
                  } else
                    context.pushNamed(request.pathName);
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: TColors.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(request.icon, size: 40, color: Colors.white),
                      SizedBox(height: 5),
                      Text(
                        request.typeName,
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
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
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
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  hint: const Text('Filter by Type',
                      style: TextStyle(fontSize: 16)),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                    context.read<RequestListCubit>().filterByStatus(value);
                  },
                  items: [
                    {'type': null, 'typeName': 'Tất cả'}, // 'All' option
                    {'type': 'PENDING', 'typeName': 'Đang chờ'}, // 'All' option
                    {
                      'type': 'APPROVED',
                      'typeName': 'Đã trả lời'
                    }, // 'All' option
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
        BlocBuilder<RequestListCubit, RequestListState>(
          builder: (context, state) {
            if (state is RequestListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RequestListFailure) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is RequestListLoaded) {
              return state.allRequests.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: state.filteredRequests.length,
                        itemBuilder: (context, index) {
                          final request = state.filteredRequests[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          request.requestTypeName ??
                                              'No Type Name',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color:
                                              _getStatusColor(request.status!)
                                                  .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          request.status!,
                                          style: TextStyle(
                                            color: _getStatusColor(
                                                request.status!),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(request.reason ?? 'No content'),
                                  const SizedBox(height: 5),
                                  if (request.reply != null &&
                                      request.reply!.isNotEmpty) ...[
                                    Text(
                                      'Replied:',
                                      style: TextStyle(
                                          color: TColors.secondary,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(request.reply!),
                                    const SizedBox(height: 5),
                                  ],
                                  // Text('Created: ${'request['createdAt']'}',
                                  Text('Created: 22/02/2025',
                                      style: TextStyle(
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        'Chưa có yêu cầu nào',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
