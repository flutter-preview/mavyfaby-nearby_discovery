import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'nearby_discovery_platform_interface.dart';

/// An implementation of [NearbyDiscoveryPlatform] that uses method channels.
class MethodChannelNearbyDiscovery extends NearbyDiscoveryPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nearby_discovery');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
