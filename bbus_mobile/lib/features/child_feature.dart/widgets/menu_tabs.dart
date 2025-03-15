import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/child_feature.dart/bus_info/bus_info_page.dart';
import 'package:bbus_mobile/features/child_feature.dart/history/history_page.dart';
import 'package:bbus_mobile/features/child_feature.dart/tracking/tracking_page.dart';
import 'package:flutter/material.dart';

class MenuTabs extends StatefulWidget {
  const MenuTabs({super.key});

  @override
  State<MenuTabs> createState() => _MenuTabsState();
}

class _MenuTabsState extends State<MenuTabs> with TickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      child: Align(
        alignment: AlignmentDirectional(-1, -1),
        child: Column(
          children: [
            TabBar(
              labelColor: TColors.primary,
              unselectedLabelColor: TColors.textSecondary,
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: TColors.primary,
              tabs: [
                Tab(
                  text: 'Tracking',
                ),
                Tab(
                  text: 'History',
                ),
                Tab(
                  text: 'Bus Info',
                ),
              ],
              controller: _tabController,
              onTap: (i) async {
                [() async {}, () async {}, () async {}][i]();
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TrackingPage(),
                  HistoryPage(),
                  BusInfoPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
