import 'nearby_discovery_platform_interface.dart';
import 'nearby_discovery_models.dart';
export 'nearby_discovery_models.dart';

/// The main class of the plugin.
/// Inspired from Event architecture
/// 
/// @author mavyfaby (Maverick Fabroa)
class NearbyDiscovery {
  /// The singleton instance
  static final NearbyDiscovery _instance = NearbyDiscovery._internal();
  /// The map of event listeners
  static final Map<String, Function> _listeners = {};

  /// The factory constructor
  factory NearbyDiscovery() {
    return _instance;
  }

  /// The internal constructor
  NearbyDiscovery._internal();

  /// Listen for a specific event.
  bool on(String event, Function callback) {
    // Add the event to the list
    _listeners[event] = callback;
    // return true if the event is not in the list
    return !_listeners.containsKey(event);
  }

  /// Stop listening for a specific event.
  bool off(String event) {
    // Remove the event from the list
    _listeners.remove(event);
    // return true ff the event is in the list
    return _listeners.containsKey(event);
  }

  /// Start discovery process.
  Future<bool?> startDiscovery(String name, String serviceID, NearbyStrategy strategy) {
    return NearbyDiscoveryPlatform.instance.startDiscovery(name, serviceID, strategy);
  }

  //// Stop discovery process.
  Future<bool?> stopDiscovery() {
    return NearbyDiscoveryPlatform.instance.stopDiscovery();
  }
}