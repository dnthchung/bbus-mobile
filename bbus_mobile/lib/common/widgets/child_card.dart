import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChildCard extends StatelessWidget {
  final String name;
  final String age;
  final String address;
  final String status;
  final String? avatar;
  final bool? isParent;
  const ChildCard(
      {super.key,
      required this.name,
      required this.age,
      required this.address,
      required this.status,
      this.avatar,
      this.isParent});
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
                "Address Required",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: const SizedBox(
            height: 60, // Ensures proper vertical alignment
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "This child does not have an address.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 6),
                Text(
                  "Would you like to update it?",
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
              child: const Text("No"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.pushNamed(RouteNames.parentEditLocation);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary, // Change to match theme
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isParent == true
            ? () {
                if (address.isEmpty) {
                  _showAddressDialog(context);
                } else {
                  context.pushNamed(
                    RouteNames.childFeature,
                    pathParameters: {'name': Uri.encodeComponent(name)},
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
                  Image(
                    image: AssetImage('assets/images/default_child.png'),
                    height: 100,
                    width: 100,
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
                          '$name ($age)',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 5),
                        Text(
                          address ?? 'N/A',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
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
                                Text(status),
                              ],
                            ),
                            const Spacer(),
                            if (isParent == true)
                              ElevatedButton(
                                onPressed: () {},
                                child: Text('RePort Absent'),
                              )
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
    );
  }
}
