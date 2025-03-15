import 'package:bbus_mobile/common/widgets/custom_appbar.dart';
import 'package:bbus_mobile/features/child_feature.dart/widgets/menu_tabs.dart';
import 'package:flutter/material.dart';

class ChildFeatureLayout extends StatelessWidget {
  final String childName;
  const ChildFeatureLayout({super.key, required this.childName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map as background
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Container(
              width: 100,
              height: MediaQuery.sizeOf(context).height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.network(
                    'https://staticmapmaker.com/img/google-placeholder.png',
                  ).image,
                ),
              ),
            ),
          ),
          // Custom App Bar
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: CustomAppbar(
              childName: "John Doe", // Replace with actual image URL
            ),
          ),
          // Draggable Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.3, // Default height (30% of screen)
            minChildSize: 0.2, // Min height
            maxChildSize: 0.8, // Max height when expanded
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ListView(
                  controller:
                      scrollController, // Attach scrollController for proper dragging
                  padding: EdgeInsets.zero, // Prevent extra spacing
                  children: [
                    // Drag Handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Menu Tabs inside DraggableScrollableSheet
                    MenuTabs(), // Your menu tabs
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
