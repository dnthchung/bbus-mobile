import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/common/entities/checkpoint.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/routes/routes.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/driver/datasources/schedule_datasource.dart';
import 'package:bbus_mobile/features/map/domain/usecases/get_map_route.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/bus_info_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCalendarPage extends StatefulWidget {
  const ScheduleCalendarPage({Key? key}) : super(key: key);

  @override
  _ScheduleCalendarPageState createState() => _ScheduleCalendarPageState();
}

class _ScheduleCalendarPageState extends State<ScheduleCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  String? _currentRouteId;
  List<CheckpointEntity> _checkpoints = [];
  DateTime? _selectedDay;
  bool _isLoading = true;

  // Sample events data
  Map<DateTime, BusScheduleEntity> _events = {};
  BusScheduleEntity? _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchEvents(_focusedDay.year, _focusedDay.month);
  }

  Future<void> _fetchEvents(int year, int month) async {
    // This is a placeholder for your actual API call.
    // Replace this with your actual logic to fetch events from an API.
    List<BusScheduleEntity> fetchedEvents =
        await sl<ScheduleDatasource>().getBusScheduleByMonth(year, month);
    if (fetchedEvents.isNotEmpty) {
      final checkpointRes =
          await sl<GetMapRoute>().call(fetchedEvents.first.routeId!);
      _currentRouteId = fetchedEvents.first.routeId;
      checkpointRes.fold((l) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.message)),
        );
      }, (r) {
        setState(() {
          _checkpoints = r;
        });
      });
      // Organize the fetched events by day
      Map<DateTime, BusScheduleEntity> newEvents = {};
      for (var event in fetchedEvents) {
        if (event.date != null) {
          DateTime eventDate = DateTime.utc(
              event.date!.year, event.date!.month, event.date!.day);
          newEvents[eventDate] = event; // Assign directly
        }
      }
      // Update the events and refresh the UI
      setState(() {
        _events = newEvents;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        _currentRouteId != null
            ? Align(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.pushNamed(RouteNames.driverBusMap, pathParameters: {
                      'routeId': _currentRouteId!,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(
                    Icons.near_me,
                    color: Colors.white,
                  ),
                  label: const Text('Tuyến đường'),
                ),
              )
            : SizedBox(),
        TableCalendar<BusScheduleEntity>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          locale: 'vi_VN',
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          eventLoader: (day) {
            final event = _getEventsForDay(day);
            return event != null ? [event] : [];
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
            _fetchEvents(focusedDay.year,
                focusedDay.month); // <- FETCH new month data here
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (events.isNotEmpty) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
        const SizedBox(height: 8.0),
        // Expanded(
        //   child: ListView(
        //     children: _getEventsForDay(_selectedDay ?? _focusedDay)
        //         .map((event) => ListTile(
        //               title: BusInfoItem(
        //                   firstIcon: Icons.airline_seat_recline_normal_rounded,
        //                   middleTitle: 'Tài xế',
        //                   middleInfo: 'N/A'),
        //             ))
        //         .toList(),
        //   ),
        // ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(12, 24, 12, 12),
            child: Builder(builder: (context) {
              final event = _getEventsForDay(_selectedDay ?? _focusedDay);
              if (event == null) {
                return Center(child: Text('Không có lịch trình trong ngày.'));
              }
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  BusInfoItem(
                      firstIcon: Icons.airline_seat_recline_normal_rounded,
                      middleTitle: 'Tài xế',
                      middleInfo: _getEventsForDay(_selectedDay ?? _focusedDay)!
                              .driverName ??
                          'N/A'),
                  SizedBox(
                    height: 12,
                  ),
                  BusInfoItem(
                      firstIcon: Icons.info_rounded,
                      middleTitle: 'Số hiệu',
                      middleInfo:
                          _getEventsForDay(_selectedDay ?? _focusedDay)!.name ??
                              'N/A'),
                  SizedBox(
                    height: 12,
                  ),
                  BusInfoItem(
                      firstIcon: Icons.directions_bus_rounded,
                      middleTitle: 'Biển số xe',
                      middleInfo: _getEventsForDay(_selectedDay ?? _focusedDay)!
                              .licensePlate ??
                          'N/A'),
                  SizedBox(
                    height: 12,
                  ),
                  BusInfoItem(
                    firstIcon: Icons.account_box_rounded,
                    middleTitle: 'Phụ xe',
                    middleInfo: _getEventsForDay(_selectedDay ?? _focusedDay)!
                            .assistantName ??
                        'N/A',
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Lộ trình & Thời gian',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  ...?_checkpoints?.map((cp) {
                    bool isLast = cp.id == _checkpoints?.last.id;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        isLast ? Icons.flag : Icons.location_on,
                        color: isLast ? Colors.green : Colors.red,
                      ),
                      title: Text(cp.name!),
                      subtitle:
                          Text("Lat: ${cp.latitude}, Lng: ${cp.longitude}"),
                      trailing: Text(cp.time!),
                    );
                  }).toList(),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
