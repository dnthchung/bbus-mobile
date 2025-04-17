import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/common/widgets/custom_appbar.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/map/cubit/location_tracking/location_tracking_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/menu_tabs.dart';
import 'package:bbus_mobile/features/map/bus_tracking_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChildFeatureLayout extends StatefulWidget {
  final ChildEntity child;
  const ChildFeatureLayout({super.key, required this.child});

  @override
  State<ChildFeatureLayout> createState() => _ChildFeatureLayoutState();
}

class _ChildFeatureLayoutState extends State<ChildFeatureLayout> {
  final cubit = sl<LocationTrackingCubit>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await cubit.getBusDetail(widget.child.busId); // Make sure this is `await`
    cubit.listenForLocationUpdates(widget.child.busId);
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    cubit.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        body: Stack(
          children: [
            BusTrackingMap(),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: CustomAppbar(childName: widget.child.name ?? 'John Doe'),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.2,
              maxChildSize: 0.8,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2)
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
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
                      MenuTabs(), // Now it's safe to access busDetail
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
