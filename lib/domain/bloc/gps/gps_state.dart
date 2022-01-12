part of 'gps_bloc.dart';

class GpsState extends Equatable {
  final bool isGPSEnable;
  final bool isGpsPermissionGranted;

  bool get isAllGranted => isGPSEnable && isGpsPermissionGranted;

  const GpsState({
    required this.isGPSEnable,
    required this.isGpsPermissionGranted,
  });

  GpsState copyWith({
    bool? isGPSEnable,
    bool? isGpsPermissionGranted,
  }) =>
      GpsState(
        isGPSEnable: isGPSEnable ?? this.isGPSEnable,
        isGpsPermissionGranted:
            isGpsPermissionGranted ?? this.isGpsPermissionGranted,
      );

  @override
  List<Object> get props => [
        isGPSEnable,
        isGpsPermissionGranted,
      ];

  @override
  String toString() =>
      '{isGPSEnable: $isGPSEnable, isGpsPermissionGranted:$isGpsPermissionGranted}';
}
