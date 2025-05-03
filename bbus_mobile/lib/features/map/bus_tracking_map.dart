import 'dart:async';
import 'dart:math';

import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/map/cubit/location_tracking/location_tracking_cubit.dart';
import 'package:bbus_mobile/features/map/domain/usecases/get_map_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class BusTrackingMap extends StatefulWidget {
  final ChildEntity child;
  final List<CheckpointEntity> checkpoints;
  const BusTrackingMap(
      {super.key, required this.child, required this.checkpoints});

  @override
  State<BusTrackingMap> createState() => _BusTrackingMapState();
}

class _BusTrackingMapState extends State<BusTrackingMap> {
  final ValueNotifier<LatLng?> _markerPosition = ValueNotifier(null);
  final MapController _mapController = MapController();
  final Location _location = Location();
  LatLng? _currentLocation = LatLng(35.761648, 51.399856);
  LatLng? _destination = LatLng(35.761641, 51.399850);
  List<LatLng> _route = [];
  Marker? _marker;
  bool _isFollowMode = true;
  final Distance _distance = const Distance();
  void _updateMarker(LocationEntity location) {
    _markerPosition.value = LatLng(location.latitude, location.longitude);
  }
  // Future<void> _fetchCoordinatesPoint(String location) async {
  //   final url =
  //       'https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1';
  //   final data = await sl<DioClient>().get(url);
  //   if (data.isNotEmpty) {
  //     final lat = double.parse(data[0]['lat']);
  //     final lng = double.parse(data[0]['lon']);
  //     setState(() {
  //       _destination = LatLng(lat, lng);
  //       print(_destination);
  //     });
  //     _mapController.move(_destination!, 15);
  //     await _fetchRoute();
  //   }
  // }

  Future<void> _fetchRoute(String coordinates) async {
    if (_currentLocation == null || _destination == null) return;
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
    print(decodedPoints);
    setState(() {
      _route = decodedPoints
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
      print(_route);
    });
  }

  Future<bool> _checkRequestPermission() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  double? sanitizeHeading(double? heading) {
  if (heading == null || heading.isNaN || !heading.isFinite) return 0.0;
  return heading;
}

  void _fetchBusRoute() async {
    final coordinates = widget.checkpoints
        .map((location) => '${location.longitude},${location.latitude}')
        .join(';');
    final url = 'http://router.project-osrm.org/route/v1/driving/$coordinates'
        '?overview=full&geometries=polyline';
    try {
      final data = await sl<DioClient>().get(url);
      final geometry = data['routes'][0]['geometry'];
      _decodePolyline(geometry);

      setState(() {
        _currentLocation = LatLng(widget.checkpoints.first.latitude!,
            widget.checkpoints.first.longitude!);
        _destination = LatLng(widget.checkpoints.last.latitude!,
            widget.checkpoints.last.longitude!);
      });
      _mapController.move(
          LatLng(widget.checkpoints.first.latitude!,
              widget.checkpoints.first.longitude!),
          15);
    } catch (e) {
      print("Failed to fetch OSRM route: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchBusRoute();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  // void _addMarker(LocationEntity location) {
  //   logger.i(location);
  //   final marker = Marker(
  //     point: LatLng(location.latitude, location.longitude),
  //     width: 45,
  //     height: 45,
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         shape: BoxShape.circle,
  //         border: Border.all(color: TColors.darkPrimary, width: 2),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.black.withOpacity(0.3),
  //             blurRadius: 4,
  //             offset: Offset(0, 2),
  //           ),
  //         ],
  //       ),
  //       padding: const EdgeInsets.all(8),
  //       child: Icon(
  //         Icons.directions_bus_filled, // slightly better bus icon
  //         size: 30,
  //         color: TColors.darkPrimary,
  //       ),
  //     ),
  //   );
  //   _marker = marker;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            BlocListener<LocationTrackingCubit, LocationTrackingState>(
              listener: (context, state) {
                if (state is LocationUpdated) {
                  _updateMarker(state.location);
                  if (_isFollowMode && _mapController.camera.center != null) {
                    final LatLng newBusPosition = LatLng(
                        state.location.latitude, state.location.longitude);
                    final double distanceFromCenter = _distance(
                      _mapController.camera.center,
                      newBusPosition,
                    );

                    if (distanceFromCenter > 50) {
                      _mapController.move(
                          newBusPosition, _mapController.camera.zoom);
                    }
                  }
                } else if (state is LocationTrackingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                } else if (state is LocationTrackingClosed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dừng theo dõi!')),
                  );
                }
              },
              child: _buildMap(),
            ),
            Positioned(
              top: 50,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor:
                    _isFollowMode ? TColors.darkPrimary : Colors.grey,
                onPressed: () {
                  print('Press');
                  setState(() {
                    _isFollowMode = true;
                    if (_markerPosition.value != null) {
                      _mapController.move(_markerPosition.value!, 16.12);
                    }
                  });
                },
                child: Icon(Icons.directions_bus_filled),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? LatLng(21.0047205, 105.8014499),
        initialZoom: 20,
        minZoom: 2,
        maxZoom: 100,
        onPositionChanged: (MapCamera camera, bool hasGesture) {
          print("Current zoom level: ${camera.zoom}");
          if (hasGesture && _isFollowMode) {
            setState(() {
              _isFollowMode =
                  false; // Disable follow mode if user drags the map
            });
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        // CurrentLocationLayer(
        //   style: LocationMarkerStyle(
        //     marker: DefaultLocationMarker(
        //       child: Icon(
        //         Icons.location_pin,
        //         color: Colors.white,
        //       ),
        //     ),
        //     markerSize: Size(35, 35),
        //     markerDirection: sanitizeHeading(MarkerDirection.heading),
        //   ),
        // ),
        if (_route.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _route,
                strokeWidth: 4,
                color: Colors.blue,
              ),
            ],
          ),
        ValueListenableBuilder<LatLng?>(
          valueListenable: _markerPosition,
          builder: (context, value, _) {
            if (value == null) return SizedBox.shrink();
            return MarkerLayer(
              markers: [
                Marker(
                  point: value,
                  width: 30,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: TColors.darkPrimary, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 3,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4), // smaller padding
                    child: Icon(
                      Icons.directions_bus_filled,
                      size: 18, // smaller icon
                      color: TColors.darkPrimary,
                    ),
                  ),
                )
              ],
            );
          },
        ),
        if (widget.checkpoints.isNotEmpty)
          MarkerLayer(
            markers: widget.checkpoints.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              final isLast = index == widget.checkpoints.length - 1;
              final isChildCheckpoint = widget.child.checkpointId == point.id;
              return Marker(
                point: LatLng(point.latitude!, point.longitude!),
                width: (isLast || isChildCheckpoint) ? 30 : 15,
                height: (isLast || isChildCheckpoint) ? 30 : 15,
                child: isLast
                    ? Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 40,
                      )
                    : isChildCheckpoint
                        ? Container(
                            decoration: BoxDecoration(
                              color: TColors.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Icon(
                              Icons.child_care,
                              color: Colors.white,
                              size: 26,
                            ),
                          )
                        // Icon(
                        //     Icons.location_on,
                        //     color: TColors.secondary,
                        //     size: 40,
                        //   )
                        : Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: TColors.accent,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
