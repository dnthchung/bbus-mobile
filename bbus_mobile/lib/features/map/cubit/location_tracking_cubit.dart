import 'package:bbus_mobile/common/entities/location.dart';
import 'package:bbus_mobile/features/map/domain/usecases/get_live_location.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'location_tracking_state.dart';

class LocationTrackingCubit extends Cubit<LocationTrackingState> {
  final GetLiveLocation _getLiveLocation;
  LocationTrackingCubit(this._getLiveLocation)
      : super(LocationTrackingInitial()) {
    listenForLocationUpdates();
  }
  Future<void> listenForLocationUpdates() async {
    await _getLiveLocation.openLiveTracking((location) {
      emit(LocationUpdated(location));
    });
  }

  void stopListening() {
    _getLiveLocation.stop();
    emit(LocationTrackingInitial());
  }
}
