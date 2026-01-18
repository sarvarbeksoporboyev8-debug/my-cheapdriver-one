import 'dart:math' as math;

import 'package:location/location.dart';
import 'package:logging/logging.dart';

import '../../presentation/utils/riverpod_framework.dart';

part 'location_service.g.dart';

abstract class AppLocationSettings {
  static const int getLocationTimeLimit = 20;
  static const int locationChangeInterval = 5;
  static const int locationChangeDistance = 50;
}

@Riverpod(keepAlive: true)
LocationService locationService(LocationServiceRef ref) {
  return LocationService();
}

class LocationService {
  final Location _location = Location();

  Future<bool> isLocationServiceEnabled() async {
    return _location.serviceEnabled();
  }

  Future<bool> isWhileInUsePermissionGranted() async {
    final permission = await _location.hasPermission();
    return permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited;
  }

  Future<bool> isAlwaysPermissionGranted() async {
    final permission = await _location.hasPermission();
    return permission == PermissionStatus.granted;
  }

  Future<bool> enableLocationService() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (serviceEnabled) {
      return true;
    } else {
      return _location.requestService();
    }
  }

  Future<bool> requestWhileInUsePermission() async {
    if (await isWhileInUsePermissionGranted()) {
      return true;
    } else {
      final permissionGranted = await _location.requestPermission();
      return permissionGranted == PermissionStatus.granted ||
          permissionGranted == PermissionStatus.grantedLimited;
    }
  }

  Future<bool> requestAlwaysPermission() async {
    if (await isAlwaysPermissionGranted()) {
      return true;
    } else {
      await _location.requestPermission();
      return isAlwaysPermissionGranted();
    }
  }

  Future<void> configureLocationSettings() async {
    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: AppLocationSettings.locationChangeInterval * 1000,
      distanceFilter: AppLocationSettings.locationChangeDistance.toDouble(),
    );
    await _location.enableBackgroundMode(enable: true);
  }

  Stream<LocationData> getLocationStream() {
    return _location.onLocationChanged;
  }

  Future<LocationData?> getLocation() async {
    try {
      return await _location.getLocation().timeout(
            const Duration(seconds: AppLocationSettings.getLocationTimeLimit),
          );
    } catch (e) {
      Logger.root.severe(e, StackTrace.current);
      return null;
    }
  }

  static double distanceBetween(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    const double earthRadius = 6371000;
    final double dLat = _toRadians(endLatitude - startLatitude);
    final double dLon = _toRadians(endLongitude - startLongitude);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(startLatitude)) *
            math.cos(_toRadians(endLatitude)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  static double _toRadians(double degree) {
    return degree * math.pi / 180;
  }
}
