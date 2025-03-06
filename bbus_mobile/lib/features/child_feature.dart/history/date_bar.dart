import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/child_feature.dart/history/cubit/history_cubit.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateBar extends StatefulWidget {
  const DateBar({super.key});

  @override
  State<DateBar> createState() => _DateBarState();
}

class _DateBarState extends State<DateBar> {
  late DateTime selectedDate;

  @override
  void initState() {
    selectedDate = DateTime.now().subtract(Duration(days: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 4),
      child: EasyTheme(
        data: EasyTheme.of(context).copyWithState(
          selectedDayTheme: const DayThemeData(
            backgroundColor: TColors.primary,
          ),
        ),
        child: EasyDateTimeLinePicker(
          firstDate: DateTime(2022, 1, 1),
          lastDate: DateTime.now().subtract(Duration(days: 1)),
          focusedDate: selectedDate,
          onDateChange: (date) {
            setState(() {
              selectedDate = date;
              context.read<HistoryCubit>().getDailySchedule(date);
            });
          },
          selectionMode: SelectionMode.autoCenter(),
          disableStrategy: DisableStrategy.after(
            DateTime.now().subtract(Duration(days: 1)),
          ),
        ),
      ),
    );
  }
}
