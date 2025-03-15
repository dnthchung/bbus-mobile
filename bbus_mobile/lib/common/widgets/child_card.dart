import 'package:bbus_mobile/config/routes/routes.dart';
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

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isParent == true
            ? () {
                context.pushNamed(
                  RouteNames.childFeature,
                  pathParameters: {'name': Uri.encodeComponent(name)},
                );
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
                          address,
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
