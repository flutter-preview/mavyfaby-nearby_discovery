package com.mavyfaby.nearby_discovery;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.connection.AdvertisingOptions;
import com.google.android.gms.nearby.connection.ConnectionInfo;
import com.google.android.gms.nearby.connection.ConnectionLifecycleCallback;
import com.google.android.gms.nearby.connection.ConnectionResolution;
import com.google.android.gms.nearby.connection.ConnectionsStatusCodes;
import com.google.android.gms.nearby.connection.DiscoveredEndpointInfo;
import com.google.android.gms.nearby.connection.DiscoveryOptions;
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback;
import com.google.android.gms.nearby.connection.Strategy;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** NearbyDiscoveryPlugin */
public class NearbyDiscoveryPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "nearby_discovery");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    // Start Discovery
    if (call.method.equals("startDiscovery")) {
      startDiscovery(call, result);
      return;
    }

    // Stop Discovery
    if (call.method.equals("stopDiscovery")) {
      stopDiscovery(call, result);
      return;
    }

    result.notImplemented();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  /**
   * Start Discovery
   */
  private void startDiscovery(@NonNull MethodCall call, @NonNull Result result) {
    // Get name
    String name = (String)call.argument("name");
    // Get nearby connection strategy
    Integer strategy = (Integer)call.argument("strategy");
    // Get service id
    String serviceID = (String)call.argument("serviceID");

    // If name is null or empty
    if (name == null || name.isEmpty()) {
      // Send error
      result.error("1", "Name is null or empty", null);
      return;
    }

    // If strategy is null
    if (strategy == null) {
      // Send error
      result.error("2", "Strategy is null", null);
      return;
    }

    // If service id is null or empty
    if (serviceID == null || serviceID.isEmpty()) {
      // Send error
      result.error("3", "ServiceID is null or empty", null);
      return;
    }

    // Create discovery options
    DiscoveryOptions discoveryOptions = new DiscoveryOptions.Builder()
            .setStrategy(getStrategy(strategy)).build();

    Nearby.getConnectionsClient(context)
      .startDiscovery(serviceID, endpointDiscoveryCallback, discoveryOptions)
      .addOnSuccessListener(
        (Void unused) -> {
          // We're discovering!
          result.success(true);
        })
      .addOnFailureListener(
        (Exception e) -> {
          // We're unable to start discovering.
          result.error("4", "Unable to start discovering", null);
        });
  }

  /**
   * Stop Discovery
   */
  private void stopDiscovery(@NonNull MethodCall call, @NonNull Result result) {
    Nearby.getConnectionsClient(context).stopDiscovery();
    result.success(null);
  }

  /**
   * Endpoint Discovery Callback
   */
  private final EndpointDiscoveryCallback endpointDiscoveryCallback = new EndpointDiscoveryCallback() {
    @Override
    public void onEndpointFound(@NonNull String endpointId,
                                @NonNull DiscoveredEndpointInfo discoveredEndpointInfo) {
      Map<String, Object> args = new HashMap<>();
      args.put("endpointId", endpointId);
      args.put("endpointName", discoveredEndpointInfo.getEndpointName());
      args.put("serviceId", discoveredEndpointInfo.getServiceId());

      channel.invokeMethod("endpoint_found", args);
    }

    @Override
    public void onEndpointLost(@NonNull String endpointId) {
      Map<String, Object> args = new HashMap<>();
      args.put("endpointId", endpointId);
      channel.invokeMethod("endpoint_lost", args);
    }
  };

  /**
   * Get Nearby Connection Strategy
   */
  private Strategy getStrategy(int strategy) {
    switch (strategy) {
      case 0:
        return Strategy.P2P_CLUSTER;
      case 1:
        return Strategy.P2P_STAR;
      case 2:
        return Strategy.P2P_POINT_TO_POINT;
    }

    return Strategy.P2P_CLUSTER;
  }
}
