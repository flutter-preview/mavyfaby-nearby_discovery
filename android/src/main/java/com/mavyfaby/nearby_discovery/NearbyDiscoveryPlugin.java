package com.mavyfaby.nearby_discovery;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * NearbyDiscoveryPlugin
 * @author mavyfaby (Maverick Fabroa)
 */
public class NearbyDiscoveryPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Context context;
  private NearbyDiscoveryLocation location;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "nearby_discovery");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityPluginBinding) {
    this.location = new NearbyDiscoveryLocation(activityPluginBinding.getActivity());
    activityPluginBinding.addActivityResultListener(location);
    activityPluginBinding.addRequestPermissionsResultListener(location);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    // Start Discovery
    if (call.method.equals("startDiscovery")) {
      Log.d("NearbyDiscovery", "startDiscovery");
      NearbyDiscovery.startDiscovery(channel, context, call, result);
      return;
    }

    // Stop Discovery
    if (call.method.equals("stopDiscovery")) {
      Log.d("NearbyDiscovery", "stopDiscovery");
      NearbyDiscovery.stopDiscovery(context, result);
      return;
    }

    // Start Advertising
    if (call.method.equals("startAdvertising")) {
      Log.d("NearbyDiscovery", "startAdvertising");
      NearbyDiscovery.startAdvertising(channel, context, call, result);
      return;
    }

    // Stop Advertising
    if (call.method.equals("stopAdvertising")) {
      Log.d("NearbyDiscovery", "stopAdvertising");
      NearbyDiscovery.stopAdvertising(context, result);
      return;
    }

    // Is Location Permission Granted
    if (call.method.equals("isLocationPermissionGranted")) {
      Log.d("NearbyDiscovery", "isLocationPermissionGranted");
      NearbyDiscovery.isLocationPermissionGranted(context, result);
      return;
    }

    // Is Location Enabled
    if (call.method.equals("isLocationEnabled")) {
      Log.d("NearbyDiscovery", "isLocationEnabled");
      NearbyDiscovery.isLocationEnabled(context, result);
      return;
    }

    // Request Location Permission
    if (call.method.equals("requestLocationPermission")) {
      Log.d("NearbyDiscovery", "requestLocationPermission");
      NearbyDiscovery.requestLocationPermission(location, result);
      return;
    }

    // Request Location Enable
    if (call.method.equals("requestLocationEnable")) {
      Log.d("NearbyDiscovery", "requestLocationEnable");
      NearbyDiscovery.requestLocationEnable(location, result);
      return;
    }

    result.notImplemented();
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // TODO: the Activity your plugin was attached to was destroyed to change configuration.
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    // TODO: your plugin is now attached to a new Activity after a configuration change.
  }

  @Override
  public void onDetachedFromActivity() {
    // TODO: your plugin is no longer associated with an Activity. Clean up references.
  }
}
