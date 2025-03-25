import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;

  const LocationEntity(this.latitude, this.longitude);

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      json['latitude']?.toDouble() ?? 0.0,
      json['longitude']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  List<Object> get props => [latitude, longitude];
}
