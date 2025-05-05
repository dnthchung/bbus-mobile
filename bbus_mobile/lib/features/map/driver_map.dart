import 'dart:async';
import 'dart:math';

import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/map/domain/usecases/get_map_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class DriverMap extends StatefulWidget {
  final String routeId;
  const DriverMap({super.key, required this.routeId});

  @override
  State<DriverMap> createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  final MapController _mapController = MapController();
  final Location _location = Location();
  LatLng? _currentLocation = LatLng(35.761648, 51.399856);
  LatLng? _destination = LatLng(35.761641, 51.399850);
  List<LatLng> _route = [];
  List<LatLng> _checkpoints = [];
  List<CheckpointEntity> _busStops = [];
  Marker? _marker;

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

  void _fetchBusRoute() async {
    final res = await sl<GetMapRoute>().call(widget.routeId);
    res.fold((l) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.message)),
      );
    }, (r) async {
      if (r.length >= 2) {
        setState(() {
          _checkpoints = r
              .map(
                  (location) => LatLng(location.latitude!, location.longitude!))
              .toList();
          _busStops = r;
        });
        final coordinates = r
            .map((location) => '${location.longitude},${location.latitude}')
            .join(';');

        final url =
            'http://router.project-osrm.org/route/v1/driving/$coordinates'
            '?overview=full&geometries=polyline';

        try {
          final data = await sl<DioClient>().get(url);
          final geometry = data['routes'][0]['geometry'];
          _decodePolyline(geometry);

          setState(() {
            _currentLocation = LatLng(r.first.latitude!, r.first.longitude!);
            _destination = LatLng(r.last.latitude!, r.last.longitude!);
          });
          _mapController.move(
              LatLng(r.first.latitude!, r.first.longitude!), 15);
        } catch (e) {
          print("Failed to fetch OSRM route: $e");
        }
      }
    });
  }

  void _showCheckpointList() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: _busStops.isEmpty
              ? const Center(child: Text("Không tìm thấy điểm đón nào"))
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: _busStops.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final stop = _busStops[index];
                    return ListTile(
                      leading: Icon(
                        index == _busStops.length - 1
                            ? Icons.flag
                            : Icons.location_on,
                        color: index == _busStops.length - 1
                            ? Colors.green
                            : Colors.red,
                      ),
                      title: Text(stop.name ?? "Bus Stop ${index + 1}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Lat: ${stop.latitude}, Lng: ${stop.longitude}"),
                          if (stop.time != null)
                            Text("Thời gian: ${stop.time}"),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
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

  void _addMarker(LocationEntity location) {
    logger.i(location);
    final marker = Marker(
        point: LatLng(location.latitude, location.longitude),
        width: 50,
        height: 50,
        child: const Icon(
          Icons.directions_bus,
          size: 40,
          color: TColors.darkPrimary,
        ));
    _marker = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tuyến đường"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCheckpointList,
        child: const Icon(Icons.list),
      ),
      body: Stack(
        children: [_buildMap()],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation ?? LatLng(35.761648, 51.399856),
        initialZoom: 20,
        minZoom: 2,
        maxZoom: 100,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        CurrentLocationLayer(
          style: LocationMarkerStyle(
            marker: DefaultLocationMarker(
              child: Icon(
                Icons.location_pin,
                color: Colors.white,
              ),
            ),
            markerSize: Size(35, 35),
            markerDirection: MarkerDirection.heading,
          ),
        ),
        if (_checkpoints.isNotEmpty)
          MarkerLayer(
            markers: _checkpoints.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              final isLast = index == _checkpoints.length - 1;

              return Marker(
                point: point,
                width: 50,
                height: 50,
                child: Icon(
                  isLast ? Icons.flag : Icons.location_on,
                  color: isLast ? Colors.green : Colors.red,
                  size: 40,
                ),
              );
            }).toList(),
          ),
        if (_route.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _route,
                strokeWidth: 4,
                color: TColors.darkPrimary,
              ),
            ],
          ),
      ],
    );
  }
}
