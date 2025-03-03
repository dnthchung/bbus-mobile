import 'package:bbus_mobile/common/widgets/custom_appbar.dart';
import 'package:bbus_mobile/features/child_feature.dart/widgets/menu_tabs.dart';
import 'package:flutter/material.dart';

class ChildFeatureLayout extends StatelessWidget {
  final String childName;
  const ChildFeatureLayout({super.key, required this.childName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: AlignmentDirectional(-1, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              color: Colors.transparent,
              elevation: 1,
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
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: CustomAppbar(),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(80, 0, 0, 0),
                        child: Text(
                          childName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: AlignmentDirectional(-1, -1.1),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Align(
                          alignment: AlignmentDirectional(-1, 0),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(),
                            child: Container(
                              width: 200,
                              height: 200,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/images/default_child.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  MenuTabs(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
