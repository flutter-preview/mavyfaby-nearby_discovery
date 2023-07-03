import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nearby_discovery.dart';
import 'nearby_discovery_platform_interface.dart';

/// An implementation of [NearbyDiscoveryPlatform] that uses method channels.
class MethodChannelNearbyDiscovery extends NearbyDiscoveryPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nearby_discovery');

  /// Initialize the plugin.
  @override
  void init() {
    // Set method handler
    methodChannel.setMethodCallHandler((MethodCall call) async {
      // If the method is endpoint_found
      if (call.method == 'endpoint_found') {
        // Emit the event
        NearbyDiscovery.emit("found", call.arguments);
      }

      // If the method is endpoint_lost
      if (call.method == 'endpoint_lost') {
        // Emit the event
        NearbyDiscovery.emit("lost", call.arguments);
      }
    });
  }

  @override
  Future<NearbyResult> startDiscovery(String serviceID, NearbyStrategy strategy) async {
    // Check if location permission is granted
    bool? isPermissionGranted = await isLocationPermissionGranted();
    // Check if location is enabled
    bool? isLocationServicesEnabled = await isLocationEnabled();

    // If location permission is not granted, return error
    if (!isPermissionGranted) {
      return NearbyResult.locationPermissionNotGranted;
    }

    // If location is not enabled, return error
    if (!isLocationServicesEnabled) {
      return NearbyResult.locationNotEnabled;
    }

    // Start discovery
    try {
      bool? result = await methodChannel.invokeMethod<bool>('startDiscovery', <String, dynamic>{
        'serviceID': serviceID,
        'strategy': strategy.index
      });

      if (result == null || !result) {
        return NearbyResult.unknown;
      }

      return NearbyResult.success;
    } on PlatformException {
      return NearbyResult.unknown;
    }
  }

  @override
  Future<NearbyResult> startAdvertising(String name, String serviceID, NearbyStrategy strategy) async {
    // Check if location permission is granted
    bool? isPermissionGranted = await isLocationPermissionGranted();
    // Check if location is enabled
    bool? isLocationServicesEnabled = await isLocationEnabled();

    // If location permission is not granted, return error
    if (!isPermissionGranted) {
      return NearbyResult.locationPermissionNotGranted;
    }

    // If location is not enabled, return error
    if (!isLocationServicesEnabled) {
      return NearbyResult.locationNotEnabled;
    }

    // Start discovery
    try {
      bool? result = await methodChannel.invokeMethod<bool>('startAdvertising', <String, dynamic>{
        'name': name,
        'serviceID': serviceID,
        'strategy': strategy.index
      });

      if (result == null || !result) {
        return NearbyResult.unknown;
      }

      return NearbyResult.success;
    } on PlatformException {
      return NearbyResult.unknown;
    }
  }

  @override
  Future<bool> stopDiscovery() async {
    return await methodChannel.invokeMethod<bool>('stopDiscovery') ?? false;
  }

  @override
  Future<bool> stopAdvertising() async {
    return await methodChannel.invokeMethod<bool>('stopAdvertising') ?? false;
  }

  @override
  Future<bool> isLocationPermissionGranted() async {
    return await methodChannel.invokeMethod<bool>('isLocationPermissionGranted') ?? false;
  }

  @override
  Future<bool> isLocationEnabled() async {
    return await methodChannel.invokeMethod<bool>('isLocationEnabled') ?? false;
  }

  @override
  Future<bool> requestLocationPermission() async {
    return await methodChannel.invokeMethod<bool>('requestLocationPermission') ?? false;
  }

  @override
  Future<bool> requestLocationEnable() async {
    return await methodChannel.invokeMethod<bool>('requestLocationEnable') ?? false;
  }
}
