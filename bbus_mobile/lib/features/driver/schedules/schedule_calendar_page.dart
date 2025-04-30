import 'package:bbus_mobile/common/entities/bus_schedule.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/driver/datasources/schedule_datasource.dart';
import 'package:bbus_mobile/features/parent/presentation/widgets/bus_info_item.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleCalendarPage extends StatefulWidget {
  const ScheduleCalendarPage({Key? key}) : super(key: key);

  @override
  _ScheduleCalendarPageState createState() => _ScheduleCalendarPageState();
}

class _ScheduleCalendarPageState extends State<ScheduleCalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
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

    // Organize the fetched events by day
    Map<DateTime, BusScheduleEntity> newEvents = {};
    for (var event in fetchedEvents) {
      if (event.date != null) {
        DateTime eventDate =
            DateTime.utc(event.date!.year, event.date!.month, event.date!.day);
        newEvents[eventDate] = event; // Assign directly
      }
    }

    // Update the events and refresh the UI
    setState(() {
      _events = newEvents;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        TableCalendar<BusScheduleEntity>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
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
        SingleChildScrollView(
          padding: EdgeInsetsDirectional.fromSTEB(12, 24, 12, 12),
          child: Builder(builder: (context) {
            final event = _getEventsForDay(_selectedDay ?? _focusedDay);
            if (event == null) {
              return Center(child: Text('Không có lịch trình trong ngày.'));
            }
            return Column(
              mainAxisSize: MainAxisSize.max,
              spacing: 28,
              children: [
                BusInfoItem(
                    firstIcon: Icons.airline_seat_recline_normal_rounded,
                    middleTitle: 'Tài xế',
                    middleInfo: _getEventsForDay(_selectedDay ?? _focusedDay)!
                            .driverName ??
                        'N/A'),
                BusInfoItem(
                    firstIcon: Icons.info_rounded,
                    middleTitle: 'Số hiệu',
                    middleInfo:
                        _getEventsForDay(_selectedDay ?? _focusedDay)!.name ??
                            'N/A'),
                BusInfoItem(
                    firstIcon: Icons.directions_bus_rounded,
                    middleTitle: 'Biển số xe',
                    middleInfo: _getEventsForDay(_selectedDay ?? _focusedDay)!
                            .licensePlate ??
                        'N/A'),
                BusInfoItem(
                  firstIcon: Icons.account_box_rounded,
                  middleTitle: 'Phụ xe',
                  middleInfo: _getEventsForDay(_selectedDay ?? _focusedDay)!
                          .assistantName ??
                      'N/A',
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
