import 'nearby_discovery_platform_interface.dart';
import 'nearby_discovery_models.dart';
export 'nearby_discovery_models.dart';

/// The main class of the plugin.
/// Inspired from event architecture
/// 
/// @author mavyfaby (Maverick Fabroa)
class NearbyDiscovery {
  /// The map of event listeners
  static final Map<String, Function> _listeners = {};

  /// Listen for a specific event.
  static bool on(String event, Function callback) {
    // Add the event to the list
    _listeners[event] = callback;
    // return true if the event is not in the list
    return !_listeners.containsKey(event);
  }

  /// Stop listening for a specific event.
  static bool off(String event) {
    // Remove the event from the list
    _listeners.remove(event);
    // return true ff the event is in the list
    return _listeners.containsKey(event);
  }

  /// Start discovery process.
  static Future<NearbyResult> startDiscovery(String name, String serviceID, NearbyStrategy strategy) {
    return NearbyDiscoveryPlatform.instance.startDiscovery(name, serviceID, strategy);
  }

  //// Stop discovery process.
  static Future<bool> stopDiscovery() {
    return NearbyDiscoveryPlatform.instance.stopDiscovery();
  }

  /// Check if location permission is granted.
  static Future<bool> isLocationPermissionGranted() {
    return NearbyDiscoveryPlatform.instance.isLocationPermissionGranted();
  }

  /// Check if location is enabled.
  static Future<bool> isLocationEnabled() {
    return NearbyDiscoveryPlatform.instance.isLocationEnabled();
  }

  static Future<bool> requestLocationPermission() {
    return NearbyDiscoveryPlatform.instance.requestLocationPermission();
  }

  static Future<bool> requestLocationEnable() {
    return NearbyDiscoveryPlatform.instance.requestLocationEnable();
  }
}