import 'dart:async';
import 'dart:math';

import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:bbus_mobile/core/utils/logger.dart';
import 'package:bbus_mobile/features/map/cubit/location_tracking/location_tracking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class BusTrackingMap extends StatefulWidget {
  final String busId;
  const BusTrackingMap({super.key, required this.busId});

  @override
  State<BusTrackingMap> createState() => _BusTrackingMapState();
}

class _BusTrackingMapState extends State<BusTrackingMap> {
  late LocationTrackingCubit _locationTrackingCubit;
  final MapController _mapController = MapController();
  final Location _location = Location();
  LatLng? _currentLocation = LatLng(35.761648, 51.399856);
  LatLng? _destination = LatLng(35.761641, 51.399850);
  List<LatLng> _route = [];
  Marker? _marker;

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

  Future<void> _fetchRoute() async {
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

  @override
  void initState() {
    // TODO: implement initState
    _locationTrackingCubit = sl<LocationTrackingCubit>();
    _locationTrackingCubit.listenForLocationUpdates(widget.busId);
    super.initState();
  }

  @override
  void dispose() {
    _locationTrackingCubit.stopListening();
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
          Icons.location_pin,
          size: 40,
          color: TColors.darkPrimary,
        ));
    _marker = marker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<LocationTrackingCubit, LocationTrackingState>(
            bloc: _locationTrackingCubit,
            builder: (context, state) {
              if (state is LocationTrackingOpened) {
                return _buildMap();
              } else if (state is LocationUpdated) {
                _addMarker(state.location);
                return _buildMap();
              } else if (state is LocationTrackingError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              } else if (state is LocationTrackingClosed) {
                return const SnackBar(
                  content: Text('Stop Tracking!'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          )
        ],
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
        if (_destination != null)
          MarkerLayer(
            markers: [_marker!],
          ),
        if (_currentLocation != null &&
            _destination != null &&
            _route.isNotEmpty)
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
    );
  }
}
