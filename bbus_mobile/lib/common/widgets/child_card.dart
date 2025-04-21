import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChildCard extends StatelessWidget {
  final String studentId;
  final String? busId;
  final String name;
  final String dob;
  final String gender;
  final String? address;
  final String? checkpointId;
  final String? checkpointName;
  final String status;
  final String? avatar;
  final bool? isParent;
  const ChildCard(
      {super.key,
      required this.studentId,
      this.busId,
      required this.name,
      required this.dob,
      required this.address,
      required this.status,
      this.avatar,
      this.isParent,
      this.checkpointId,
      this.checkpointName,
      required this.gender});
  void _showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          actionsPadding: const EdgeInsets.only(bottom: 12),
          title: Column(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Colors.orange,
              ),
              const SizedBox(height: 12),
              const Text(
                "Chưa có điểm đón",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SizedBox(
            height: 80, // Ensures proper vertical alignment
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Con $name chưa đăng ký điểm đón",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(
                  "Vui lòng đăng ký điểm đón.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center, // Centers action buttons
          actions: [
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: TColors.primary,
                side: BorderSide(color: TColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.pushNamed(RouteNames.parentEditLocation,
                    pathParameters: {'actionType': 'register'});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary, // Change to match theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Có"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Card(
        child: Container(
          decoration: BoxDecoration(gradient: TColors.secondaryGradient),
          child: InkWell(
            onTap: isParent == true
                ? () {
                    if (checkpointId == null || checkpointId!.isEmpty) {
                      _showAddressDialog(context);
                    } else {
                      context.pushNamed(
                        RouteNames.childFeature,
                        pathParameters: {'id': studentId},
                        extra: ChildEntity(
                          id: studentId,
                          name: name,
                          checkpointName: checkpointName,
                          busId: busId, // if needed
                          avatar: avatar ?? '',
                        ),
                      );
                    }
                  }
                : null,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.network(
                        avatar!,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Image(
                            image:
                                AssetImage('assets/images/default_child.png'),
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$name (${dobStringToAge(dob)})',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Text(
                              checkpointName!.isEmpty ? 'N/A' : checkpointName!,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: status == "In Bus"
                                            ? Colors.blue
                                            : status == 'At Home'
                                                ? Colors.grey
                                                : Colors.orange,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      status,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // if (isParent == true)
                                //   ElevatedButton(
                                //     onPressed: () {},
                                //     child: Text('RePort Absent'),
                                //   )
                                // else
                                //   Container(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 12, vertical: 6),
                                //     decoration: BoxDecoration(
                                //       color: Colors.grey.shade300,
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Text(
                                //       status,
                                //       style: const TextStyle(
                                //           fontSize: 14,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //   ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      Positioned(
        top: 3,
        right: 3,
        child: Container(
          decoration: BoxDecoration(
            color: TColors.primary,
          ),
          child: IconButton(
              onPressed: () {
                context.pushNamed(RouteNames.parentEditChild,
                    extra: ChildEntity(
                      id: studentId,
                      name: name,
                      address: address,
                      avatar: avatar ?? '',
                      dob: dob,
                      gender: gender,
                    ));
              },
              icon: Icon(
                Icons.edit,
                color: Colors.white,
                size: 16,
              )),
        ),
      ),
    ]);
  }
}
