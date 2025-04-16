import 'dart:async';
import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/common/widgets/result_dialog.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/features/map/cubit/checkpoint/checkpoint_list_cubit.dart';
import 'package:bbus_mobile/features/map/cubit/location_tracking/location_tracking_cubit.dart';
import 'package:bbus_mobile/features/map/domain/usecases/register_checkpoint.dart';
import 'package:bbus_mobile/features/parent/presentation/pages/add_location_page.dart';
import 'package:bbus_mobile/features/map/widgets/change_checkpoint_dialog.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_change_checkpoint_req.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/request_list/request_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class EditLocationMap extends StatefulWidget {
  final String actionType;
  const EditLocationMap({super.key, required this.actionType});

  @override
  State<EditLocationMap> createState() => _EditLocationMapState();
}

class _EditLocationMapState extends State<EditLocationMap> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  bool isLoading = true;
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> _route = [];
  StreamSubscription<LocationData>? _locationSubscription;

  String? _selectedLocation;

  Future<void> _initializeLocation() async {
    if (!await _checkRequestPermission()) return;
    _locationSubscription?.cancel();
    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      if (!mounted) return;
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation = LatLng(37.7749, -122.4194);
          isLoading = false;
        });
      }
    });
  }

  Future<void> _fetchRouteToDestination(LatLng destination) async {
    if (_currentLocation == null) return;
    _destination = destination;

    final url = "http://router.project-osrm.org/route/v1/driving/"
        '${_currentLocation!.longitude},${_currentLocation!.latitude};'
        '${_destination!.longitude},${_destination!.latitude}?overview=full&geometries=polyline';
    final data = await sl<DioClient>().get(url);
    final geometry = data['routes'][0]['geometry'];
    _decodePolyline(geometry);
  }

  void _decodePolyline(String encodedPolyline) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPoints =
        polylinePoints.decodePolyline(encodedPolyline);
    setState(() {
      _route = decodedPoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    });
  }

  Future<bool> _checkRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) return false;
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }
    return true;
  }

  // void _onLocationSelected(String? locationName) {
  //   if (locationName == null) return;
  //   setState(() {
  //     _selectedLocation = locationName;
  //     _destination = _demoLocations[locationName]!;
  //   });
  //   _mapController.move(_destination!, 15);
  // }

  Future<void> _onRegisterCheckpoint() async {
    bool? confirmRegister = await ResultDialog.show(context,
        title: 'Đăng ký điểm đón',
        message: 'Bạn chắc chắn muốn lựa chọn điểm đón này?',
        cancelText: 'Không');
    if (confirmRegister == true) {
      final result = await sl<RegisterCheckpoint>()
          .call(RegisterCheckpointParams('', _selectedLocation!));
      result.fold(
          (l) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to choose this location: ${l.message}'))),
          (r) async {
        bool? isOk = await ResultDialog.show(context,
            title: 'Đăng ký điểm đón',
            message: 'Bạn đã đăng kí điểm đón cho con thành công',
            status: DialogStatus.success);
        if (isOk!) {
          context.pop();
        }
      });
    } else {
      return;
    }
  }

  Future<void> _onSendChangeCheckpoint() async {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn điểm đón')),
      );
      return;
    }
    final reason = await showChangeCheckpointReasonDialog(context);
    if (reason == null) return; // user cancelled
    final result = await sl<SendChangeCheckpointReq>().call(
      SendChangeCheckpointReqParams(
          _selectedLocation!, 'a9f42863-57b4-4b82-91fb-227f82ecaa20', reason),
    );
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thay đổi thất bại: ${failure.message}')),
        );
      },
      (success) async {
        await ResultDialog.show(
          context,
          title: 'Yêu cầu thành công',
          message: 'Yêu cầu thay đổi điểm đón đã được gửi',
          status: DialogStatus.success,
        );
        context.read<RequestListCubit>().getRequestList();
        context.pop(); // pop the map page
      },
    );
  }

  @override
  void initState() {
    _initializeLocation();
    context.read<CheckpointListCubit>().getAll();
    super.initState();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn điểm đón'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : FlutterMap(
                        mapController: _mapController,
                        options: MapOptions(
                          initialCenter: _currentLocation ?? LatLng(0, 0),
                          initialZoom: 20,
                          minZoom: 2,
                          maxZoom: 100,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          CurrentLocationLayer(
                            style: LocationMarkerStyle(
                              marker: DefaultLocationMarker(
                                child: Icon(Icons.location_pin,
                                    color: Colors.white),
                              ),
                              markerSize: const Size(35, 35),
                              markerDirection: MarkerDirection.heading,
                            ),
                          ),
                          BlocBuilder<CheckpointListCubit, CheckpointListState>(
                            builder: (context, state) {
                              if (state is CheckpointListLoading) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (state is CheckpointListSuccess) {
                                return MarkerLayer(
                                  markers: state.data.map((checkpoint) {
                                    final bool isSelected =
                                        _selectedLocation != null &&
                                            _selectedLocation == checkpoint.id;
                                    final location = LatLng(
                                        double.parse(checkpoint.latitude!),
                                        double.parse(checkpoint.longitude!));

                                    return Marker(
                                      point: location,
                                      width: 50,
                                      height: 50,
                                      child: GestureDetector(
                                        onTap: () =>
                                            _fetchRouteToDestination(location),
                                        child: Icon(
                                          Icons.location_pin,
                                          size: 40,
                                          color: isSelected
                                              ? TColors.secondary
                                              : TColors.primary,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Text("Failed to load locations");
                              }
                            },
                          ),
                          if (_route.isNotEmpty)
                            PolylineLayer(
                              polylines: [
                                Polyline(
                                  points: _route,
                                  strokeWidth: 5,
                                  color: TColors.darkPrimary,
                                ),
                              ],
                            ),
                        ],
                      ),
                Positioned(
                  left: 16,
                  top: 16, // Adjusted for spacing
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 12,
                      children: [
                        // Row(
                        //   children: [
                        //     ClipOval(
                        //       child: Image.network(
                        //         widget.child.avatar ?? '',
                        //         height: 70,
                        //         width: 70,
                        //         fit: BoxFit.cover,
                        //         errorBuilder: (context, error, stackTrace) {
                        //           return const Image(
                        //             image: AssetImage(
                        //                 'assets/images/default_child.png'),
                        //             height: 70,
                        //             width: 70,
                        //             fit: BoxFit.cover,
                        //           );
                        //         },
                        //       ),
                        //     ),
                        //     const SizedBox(width: 12),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(
                        //           widget.child.name!,
                        //           style: const TextStyle(
                        //             fontSize: 16,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         // Text(
                        //         //   "ID: ${childId}",
                        //         //   style: const TextStyle(
                        //         //     fontSize: 14,
                        //         //     color: Colors.grey,
                        //         //   ),
                        //         // ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        const Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 206, 206, 206)),
                        BlocBuilder<CheckpointListCubit, CheckpointListState>(
                          builder: (context, state) {
                            if (state is CheckpointListLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is CheckpointListSuccess) {
                              return DropdownButtonFormField<String>(
                                value: _selectedLocation,
                                items: state.data.map((checkpoint) {
                                  return DropdownMenuItem<String>(
                                    value: checkpoint.id,
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 8.0, 0, 6.0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            color: state.data
                                                        .indexOf(checkpoint) ==
                                                    0
                                                ? Colors.transparent
                                                : Colors.grey,
                                            width: 1,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        checkpoint.name!,
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: _selectedLocation ==
                                                  checkpoint.id
                                              ? FontWeight.bold
                                              : FontWeight
                                                  .normal, // Highlight selected
                                          color: _selectedLocation ==
                                                  checkpoint.id
                                              ? Colors.blue
                                              : Colors
                                                  .black, // Change color for selected
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (checkpointId) {
                                  final selected = state.data
                                      .firstWhere((c) => c.id == checkpointId);
                                  setState(() {
                                    _selectedLocation = checkpointId;
                                    _destination = LatLng(
                                        double.parse(selected.latitude!),
                                        double.parse(selected.longitude!));
                                  });
                                  _mapController.move(_destination!, 13);
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  hintText: 'Hãy chọn 1 điểm đón',
                                ),
                                isExpanded: true,
                                selectedItemBuilder: (BuildContext context) {
                                  return state.data.map<Widget>((checkpoint) {
                                    return Text(
                                      checkpoint.name!,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  }).toList();
                                },
                              );
                            } else {
                              return Text("Failed to load locations");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 40,
                  right: 16,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_destination == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Must choose a destination")),
                        );
                      } else {
                        widget.actionType == 'register'
                            ? _onRegisterCheckpoint()
                            : _onSendChangeCheckpoint();
                      }
                    },
                    child: Text('Lưu'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
