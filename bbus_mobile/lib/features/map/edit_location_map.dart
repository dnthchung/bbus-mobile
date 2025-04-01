import 'dart:async';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/network/dio_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class EditLocationMap extends StatefulWidget {
  const EditLocationMap({super.key});

  @override
  State<EditLocationMap> createState() => _EditLocationMapState();
}

class _EditLocationMapState extends State<EditLocationMap> {
  final String childAvatar = 'default_child.png';
  final String childId = '1';
  final String childName = 'David';
  final MapController _mapController = MapController();
  final Location _location = Location();
  bool isLoading = true;
  LatLng? _currentLocation;
  LatLng? _destination;
  List<LatLng> _route = [];
  StreamSubscription<LocationData>? _locationSubscription;

  // Demo locations
  final Map<String, LatLng> _demoLocations = {
    "Lô T2, Ng. 54 Lê Văn Lương, Trung Hòa Nhân Chính, Thanh Xuân, Hà Nội, Việt Nam":
        LatLng(37.7749, -122.4194),
    "Đ. Lê Văn Lương, Trung Hòa Nhân Chính, Thanh Xuân, Hà Nội, Việt Nam":
        LatLng(37.7722, -122.4137),
    "Đ. Lê Văn Lương, Nhân Chính, Thanh Xuân, Hà Nội, Việt Nam":
        LatLng(40.7128, -74.0060),
    "Nhân Chính, Thanh Xuân, Hà Nội, Việt Nam": LatLng(51.5074, -0.1278),
  };

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

  void _onLocationSelected(String? locationName) {
    if (locationName == null) return;
    setState(() {
      _selectedLocation = locationName;
      _destination = _demoLocations[locationName]!;
    });
    _mapController.move(_destination!, 15);
  }

  void _showConfirmationDialog(LatLng location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Choose Destination"),
        content: const Text("Do you want to navigate to this location?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _fetchRouteToDestination(location);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _initializeLocation();
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
                          MarkerLayer(
                            markers: _demoLocations.entries.map((location) {
                              return Marker(
                                point: location.value,
                                width: 50,
                                height: 50,
                                child: GestureDetector(
                                  onTap: () =>
                                      _fetchRouteToDestination(location.value),
                                  child: const Icon(
                                    Icons.location_pin,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }).toList(),
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
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/$childAvatar'),
                              radius: 24, // Adjust as needed
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  childName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Text(
                                //   "ID: ${childId}",
                                //   style: const TextStyle(
                                //     fontSize: 14,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 206, 206, 206)),
                        DropdownButtonFormField<String>(
                          value: _selectedLocation,
                          items: _demoLocations.keys.map((location) {
                            return DropdownMenuItem<String>(
                              value: location,
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.centerLeft,
                                
                                padding:
                                    const EdgeInsets.fromLTRB(0, 8.0, 0, 6.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      color: _demoLocations.keys
                                                  .toList()
                                                  .indexOf(location) ==
                                              0
                                          ? Colors.transparent
                                          : Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  location,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: _selectedLocation == location
                                        ? FontWeight.bold
                                        : FontWeight
                                            .normal, // Highlight selected
                                    color: _selectedLocation == location
                                        ? Colors.blue
                                        : Colors
                                            .black, // Change color for selected
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: _onLocationSelected,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Select a location',
                          ),
                          isExpanded: true,
                          selectedItemBuilder: (BuildContext context) {
                            return _demoLocations.keys.map<Widget>((location) {
                              return Text(
                                location,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              );
                            }).toList();
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
                        _showConfirmationDialog(_destination!);
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
