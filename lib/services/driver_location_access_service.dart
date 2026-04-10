import 'package:geolocator/geolocator.dart';

class DriverLocationAccessStatus {
  final bool serviceEnabled;
  final LocationPermission permission;

  const DriverLocationAccessStatus({
    required this.serviceEnabled,
    required this.permission,
  });

  bool get hasPermission =>
      permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always;

  bool get isDeniedForever => permission == LocationPermission.deniedForever;

  bool get isBlocked => !serviceEnabled || !hasPermission;

  String get blockerTitle {
    if (!serviceEnabled) {
      return 'Location Services Are Off';
    }
    if (isDeniedForever) {
      return 'Location Permission Is Blocked';
    }
    return 'Location Permission Required';
  }

  String get blockerMessage {
    if (!serviceEnabled) {
      return 'Location services are disabled on this device. Drivers must keep location on to go online and receive rides.';
    }
    if (isDeniedForever) {
      return 'Location permission has been permanently denied. Enable location access from app settings to continue driving.';
    }
    return 'OdoGo requires live location access for drivers at all times. You cannot go online or accept rides without location permission.';
  }
}

class DriverLocationAccessService {
  const DriverLocationAccessService();

  Future<DriverLocationAccessStatus> checkAccess({
    bool requestIfDenied = false,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    var permission = await Geolocator.checkPermission();
    if (requestIfDenied && permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return DriverLocationAccessStatus(
      serviceEnabled: serviceEnabled,
      permission: permission,
    );
  }

  Future<void> openRelevantSettings(DriverLocationAccessStatus status) async {
    if (!status.serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }
    await Geolocator.openAppSettings();
  }
}
