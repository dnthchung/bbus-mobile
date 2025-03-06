import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/features/child_feature.dart/history/cubit/history_cubit.dart';
import 'package:bbus_mobile/features/child_feature.dart/history/date_bar.dart';
import 'package:bbus_mobile/features/child_feature.dart/history/history_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with AutomaticKeepAliveClientMixin {
  late HistoryCubit _historyCubit;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    _historyCubit = sl<HistoryCubit>()
      ..getDailySchedule(DateTime.now().subtract(Duration(days: 1)));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) => _historyCubit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DateBar(),
          BlocBuilder<HistoryCubit, HistoryState>(builder: (_, state) {
            if (state is HistoryLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HistorySuccess) {
              return HistoryDetail(dailySchedule: state.dailySchedule);
            } else if (state is HistoryEmpty) {
              return Center(
                child: Text('No schedule available for this date'),
              );
            }
            return Center(
              child: Text('Select a date to see history'),
            );
          }),
        ],
      ),
    );
  }
}
