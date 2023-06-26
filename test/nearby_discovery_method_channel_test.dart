import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nearby_discovery/nearby_discovery_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNearbyDiscovery platform = MethodChannelNearbyDiscovery();
  const MethodChannel channel = MethodChannel('nearby_discovery');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
