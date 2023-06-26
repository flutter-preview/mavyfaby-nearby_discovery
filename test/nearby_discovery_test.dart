import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_discovery/nearby_discovery.dart';
import 'package:nearby_discovery/nearby_discovery_platform_interface.dart';
import 'package:nearby_discovery/nearby_discovery_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNearbyDiscoveryPlatform
    with MockPlatformInterfaceMixin
    implements NearbyDiscoveryPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NearbyDiscoveryPlatform initialPlatform = NearbyDiscoveryPlatform.instance;

  test('$MethodChannelNearbyDiscovery is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNearbyDiscovery>());
  });

  test('getPlatformVersion', () async {
    NearbyDiscovery nearbyDiscoveryPlugin = NearbyDiscovery();
    MockNearbyDiscoveryPlatform fakePlatform = MockNearbyDiscoveryPlatform();
    NearbyDiscoveryPlatform.instance = fakePlatform;

    expect(await nearbyDiscoveryPlugin.getPlatformVersion(), '42');
  });
}
