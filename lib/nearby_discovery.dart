
import 'nearby_discovery_platform_interface.dart';

class NearbyDiscovery {
  Future<String?> getPlatformVersion() {
    return NearbyDiscoveryPlatform.instance.getPlatformVersion();
  }
}
