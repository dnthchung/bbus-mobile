import 'package:bbus_mobile/common/entities/bus.dart';
import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/features/map/domain/usecases/get_live_location.dart';
import 'package:bbus_mobile/features/parent/domain/usecases/get_bus_detail.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'location_tracking_state.dart';

class LocationTrackingCubit extends Cubit<LocationTrackingState> {
  final GetLiveLocation _getLiveLocation;
  final GetBusDetail _getBusDetail;
  BusEntity? busDetail;
  LocationTrackingCubit(this._getLiveLocation, this._getBusDetail)
      : super(LocationTrackingInitial());
  Future<void> listenForLocationUpdates(busId) async {
    await _getLiveLocation.openLiveTracking((location) {
      emit(LocationUpdated(location));
    }, busId);
  }

  Future<void> getBusDetail(busId) async {
    final res = await _getBusDetail.call(busId);
    res.fold((l) {}, (r) {
      busDetail = r;
    });
  }

  void stopListening() {
    _getLiveLocation.stop();
    emit(LocationTrackingInitial());
  }
}
