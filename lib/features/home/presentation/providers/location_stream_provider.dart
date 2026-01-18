import 'dart:io';

import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/infrastructure/services/location_service.dart';
import '../../../../core/presentation/utils/riverpod_framework.dart';
import '../utils/location_error.dart';

part 'location_stream_provider.g.dart';

@riverpod
Stream<LocationData> locationStream(LocationStreamRef ref) async* {
  final locationService = ref.watch(locationServiceProvider);

  await ref.watch(enableLocationProvider(locationService).future);
  await ref.watch(requestLocationPermissionProvider(locationService).future);

  await locationService.configureLocationSettings();

  yield* locationService
      .getLocationStream()
      .throttleTime(
          const Duration(seconds: AppLocationSettings.locationChangeInterval))
      .handleError(
    (Object err, StackTrace st) {
      Error.throwWithStackTrace(LocationError.getLocationTimeout, st);
    },
  );
}

@riverpod
Future<void> enableLocation(
  EnableLocationRef ref,
  LocationService locationService,
) async {
  final enabled = await locationService.enableLocationService();
  if (!enabled) {
    Error.throwWithStackTrace(
      LocationError.notEnabledLocation,
      StackTrace.current,
    );
  }
}

@riverpod
Future<void> requestLocationPermission(
  RequestLocationPermissionRef ref,
  LocationService locationService,
) async {
  final whileInUseGranted = await locationService.requestWhileInUsePermission();
  if (!whileInUseGranted) {
    Error.throwWithStackTrace(
      LocationError.notGrantedLocationPermission,
      StackTrace.current,
    );
  }

  if (Platform.isAndroid) {
    final alwaysGranted = await locationService.requestAlwaysPermission();
    if (!alwaysGranted) {
      Error.throwWithStackTrace(
        LocationError.notGrantedLocationPermission,
        StackTrace.current,
      );
    }
  }
}
