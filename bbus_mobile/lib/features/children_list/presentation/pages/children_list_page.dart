import 'package:bbus_mobile/common/widgets/child_card.dart';
import 'package:flutter/material.dart';

final List<Map<String, String>> children = [
  {
    "name": "Alice Johnson",
    "age": "10",
    "address": "address1",
    "status": "In Bus",
    "avatar": "null",
  },
  {
    "name": "Bob Johnson",
    "age": "9",
    "address": "address1",
    "status": "At Home",
    "avatar": "null",
  },
  {
    "name": "Tom Johnson",
    "age": "9",
    "address": "address1",
    "status": "At School",
    "avatar": "null",
  },
];

class ChildrenListPage extends StatelessWidget {
  const ChildrenListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final child = children[index];
                return ChildCard(
                  name: child['name']!,
                  age: child['age']!,
                  address: child['address']!,
                  status: child['status']!,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
