import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nearby_discovery_method_channel.dart';
import 'nearby_discovery_models.dart';

abstract class NearbyDiscoveryPlatform extends PlatformInterface {
  /// Constructs a NearbyDiscoveryPlatform.
  NearbyDiscoveryPlatform() : super(token: _token);

  static final Object _token = Object();

  static NearbyDiscoveryPlatform _instance = MethodChannelNearbyDiscovery();

  /// The default instance of [NearbyDiscoveryPlatform] to use.
  ///
  /// Defaults to [MethodChannelNearbyDiscovery].
  static NearbyDiscoveryPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NearbyDiscoveryPlatform] when
  /// they register themselves.
  static set instance(NearbyDiscoveryPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<NearbyResult> startAdvertising(String name, String serviceID, NearbyStrategy strategy) {
    throw UnimplementedError('startAdvertising() has not been implemented.');
  }

  Future<bool> stopAdvertising() {
    throw UnimplementedError('stopAdvertising() has not been implemented.');
  }

  Future<NearbyResult> startDiscovery(String serviceID, NearbyStrategy strategy) {
    throw UnimplementedError('startDiscovery() has not been implemented.');
  }

  Future<bool> stopDiscovery() {
    throw UnimplementedError('stopDiscovery() has not been implemented.');
  }

  Future<bool> isLocationPermissionGranted() {
    throw UnimplementedError('isLocationPermissionGranted() has not been implemented.');
  }

  Future<bool> isLocationEnabled() {
    throw UnimplementedError('isLocationEnabled() has not been implemented.');
  }

  Future<bool> requestLocationPermission() {
    throw UnimplementedError('requestLocationPermission() has not been implemented.');
  }

  Future<bool> requestLocationEnable() {
    throw UnimplementedError('requestLocationEnable() has not been implemented.');
  }
}
