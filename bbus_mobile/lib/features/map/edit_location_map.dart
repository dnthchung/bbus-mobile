import 'dart:async';
import 'dart:math';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/common/widgets/result_dialog.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/map/cubit/checkpoint/checkpoint_list_cubit.dart';
import 'package:bbus_mobile/features/map/domain/usecases/register_checkpoint.dart';
import 'package:bbus_mobile/features/map/widgets/change_checkpoint_dialog.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/send_change_checkpoint_req.dart';
import 'package:bbus_mobile/features/parent/presentation/cubit/children_list/children_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool isLoading = true;
  LatLng? _currentLocation;
  LatLng? _destination;
  String? _selectedChild;
  List<LatLng> _route = [];
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isSubmitting = false;

  String? _selectedLocation;

  Future<void> _initializeLocation() async {
    if (!await _checkRequestPermission()) return;
    _locationSubscription?.cancel();
    final locationData = await _location.getLocation();
    if (locationData.latitude != null && locationData.longitude != null) {
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
        isLoading = false;
      });
    }
    _locationSubscription = _location.onLocationChanged.listen((locationData) {
      if (!mounted) return;
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
        });
      }
    });
  }

  CheckpointEntity? _findClosestCheckpoint(
      LatLng userLocation, List<CheckpointEntity> checkpoints) {
    double _deg2rad(double deg) => deg * pi / 180;

    double _calculateDistance(LatLng a, LatLng b) {
      const earthRadius = 6371; // km
      final dLat = _deg2rad(b.latitude - a.latitude);
      final dLng = _deg2rad(b.longitude - a.longitude);
      final lat1 = _deg2rad(a.latitude);
      final lat2 = _deg2rad(b.latitude);

      final aVal = sin(dLat / 2) * sin(dLat / 2) +
          sin(dLng / 2) * sin(dLng / 2) * cos(lat1) * cos(lat2);
      final c = 2 * atan2(sqrt(aVal), sqrt(1 - aVal));
      return earthRadius * c;
    }

    if (checkpoints.isEmpty) return null;

    checkpoints.sort((a, b) {
      final distA =
          _calculateDistance(userLocation, LatLng(a.latitude!, a.longitude!));
      final distB =
          _calculateDistance(userLocation, LatLng(b.latitude!, b.longitude!));
      return distA.compareTo(distB);
    });

    return checkpoints.first;
  }

  void _tryZoomToClosestCheckpoint() {
    final state = context.read<CheckpointListCubit>().state;
    if (state is CheckpointListSuccess && _currentLocation != null) {
      final closest = _findClosestCheckpoint(_currentLocation!, state.data);
      if (closest != null) {
        setState(() {
          isLoading = false;
        });
        print(closest);
        _mapController.move(
          LatLng(closest.latitude!, closest.longitude!),
          15,
        );
      }
    }
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

  Future<void> _userCurrentLocation() async {
    if (_currentLocation != null) {
      _mapController.move(_currentLocation!, 15);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Current location is not available')));
    }
  }

  void _onLocationSelected(CheckpointEntity? selected) {
    setState(() {
      _selectedLocation = selected!.id;
      _destination = LatLng(selected.latitude!, selected.longitude!);
      // _fetchRouteToDestination(_destination!);
    });
    _mapController.move(_destination!, 15);
  }

  Future<void> _onRegisterCheckpoint() async {
    bool? confirmRegister = await ResultDialog.show(context,
        title: 'Đăng ký điểm đón',
        message: 'Bạn chắc chắn muốn lựa chọn điểm đón này?',
        cancelText: 'Không');
    if (confirmRegister == true) {
      setState(() {
        _isSubmitting = true;
      });
      final result = await sl<RegisterCheckpoint>()
          .call(RegisterCheckpointParams(_selectedChild, _selectedLocation!));
      setState(() {
        _isSubmitting = false;
      });

      result.fold(
          (l) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l.message))), (r) async {
        bool? isOk = await ResultDialog.show(context,
            title: 'Đăng ký điểm đón',
            message: 'Bạn đã đăng kí điểm đón cho con thành công',
            status: DialogStatus.success);
        if (isOk!) {
          context.read<ChildrenListCubit>().getAll();
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
    setState(() {
      _isSubmitting = false;
    });
    final result = await sl<SendChangeCheckpointReq>().call(
      SendChangeCheckpointReqParams(_selectedLocation!,
          'a9f42863-57b4-4b82-91fb-227f82ecaa20', _selectedChild, reason),
    );
    setState(() {
      _isSubmitting = false;
    });

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
                    : BlocBuilder<CheckpointListCubit, CheckpointListState>(
                        builder: (context, state) {
                          if (state is CheckpointListLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is CheckpointListSuccess) {
                            return FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                  initialCenter:
                                      _currentLocation ?? LatLng(0, 0),
                                  initialZoom: 20,
                                  minZoom: 2,
                                  maxZoom: 100,
                                  onMapReady: _tryZoomToClosestCheckpoint),
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
                                  markers: state.data.map((checkpoint) {
                                    final bool isSelected =
                                        _selectedLocation != null &&
                                            _selectedLocation == checkpoint.id;
                                    final location = LatLng(
                                        checkpoint.latitude!,
                                        checkpoint.longitude!);

                                    return Marker(
                                      point: location,
                                      width: 50,
                                      height: 50,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedLocation = checkpoint.id;
                                            _destination = LatLng(
                                                checkpoint.latitude!,
                                                checkpoint.longitude!);
                                            _searchController.text =
                                                checkpoint.name ?? '';
                                          });
                                          // _fetchRouteToDestination(location);
                                        },
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
                            );
                          }
                          return Center(
                              child: Text("Không thể tải các điểm đón"));
                        },
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
                        BlocBuilder<ChildrenListCubit, ChildrenListState>(
                          builder: (context, state) {
                            if (state is ChildrenListSuccess) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: DropdownButtonFormField<String?>(
                                  value: _selectedChild, // your selected value
                                  decoration: InputDecoration(
                                    labelText: 'Chọn con',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  items: [
                                    DropdownMenuItem<String?>(
                                      value:
                                          null, // <-- null for "Tất cả học sinh"
                                      child: const Text('Tất cả các con'),
                                    ),
                                    ...state.data.map(
                                        (child) => DropdownMenuItem<String?>(
                                              value: child
                                                  .id, // child.id assumed to be String
                                              child: Text(child.name!),
                                            )),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedChild = value;
                                      // You can also trigger filter logic here if needed
                                    });
                                  },
                                ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        const Divider(
                            thickness: 1,
                            color: Color.fromARGB(255, 206, 206, 206)),
                        BlocBuilder<CheckpointListCubit, CheckpointListState>(
                          builder: (context, state) {
                            if (state is CheckpointListLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is CheckpointListSuccess) {
                              return LayoutBuilder(
                                  builder: (context, constraints) {
                                return RawAutocomplete<String>(
                                  textEditingController: _searchController,
                                  focusNode: _searchFocusNode,
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<String>.empty();
                                    }
                                    return state.data
                                        .where((checkpoint) => checkpoint.name!
                                            .toLowerCase()
                                            .contains(textEditingValue.text
                                                .toLowerCase()))
                                        .map((e) => e.name!);
                                  },
                                  onSelected: (String selectedName) {
                                    final selected = state.data.firstWhere(
                                        (c) => c.name == selectedName);
                                    _onLocationSelected(selected);
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: _searchController,
                                      focusNode: _searchFocusNode,
                                      decoration: InputDecoration(
                                        hintText: 'Tìm điểm đón',
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 20),
                                        suffixIcon: _selectedLocation != null
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  _searchController.clear();
                                                  setState(() {
                                                    _selectedLocation = null;
                                                  });
                                                },
                                              )
                                            : null,
                                      ),
                                    );
                                  },
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<String> onSelected,
                                      Iterable<String> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        child: Container(
                                          height: 52.0 * options.length,
                                          width: constraints.biggest.width,
                                          color: Colors.white,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final option =
                                                  options.elementAt(index);
                                              CheckpointEntity?
                                                  selectedCheckpoint;
                                              for (var c in state.data) {
                                                if (c.id == _selectedLocation) {
                                                  selectedCheckpoint = c;
                                                  break;
                                                }
                                              }
                                              return ListTile(
                                                title: Text(
                                                  option,
                                                  style: TextStyle(
                                                    color: option ==
                                                            selectedCheckpoint
                                                                ?.name
                                                        ? TColors.primary
                                                        : Colors.black,
                                                    fontWeight: option ==
                                                            selectedCheckpoint
                                                                ?.name
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                                onTap: () => onSelected(option),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
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
                          SnackBar(content: Text("Cần chọn điểm đón")),
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
                if (_isSubmitting)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _userCurrentLocation,
        elevation: 0,
        backgroundColor: Colors.blue,
        child: Icon(
          Icons.my_location,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
