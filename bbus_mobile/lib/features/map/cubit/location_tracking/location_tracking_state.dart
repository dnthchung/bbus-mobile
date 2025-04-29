part of 'location_tracking_cubit.dart';

@immutable
sealed class LocationTrackingState extends Equatable {
  const LocationTrackingState();
  @override
  List<Object?> get props => [];
}

final class LocationTrackingInitial extends LocationTrackingState {}

final class LocationTrackingOpened extends LocationTrackingState {
  final String message;
  LocationTrackingOpened(this.message);
}

final class LocationTrackingClosed extends LocationTrackingState {}

final class LocationTrackingError extends LocationTrackingState {
  final String message;
  LocationTrackingError(this.message);
}

final class LocationUpdated extends LocationTrackingState {
  final LocationEntity location;
  LocationUpdated(this.location);
  @override
  List<Object?> get props => [location];
}
