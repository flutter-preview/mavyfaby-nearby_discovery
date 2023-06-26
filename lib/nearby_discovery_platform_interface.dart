import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nearby_discovery_method_channel.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}