package com.mavyfaby.nearby_discovery;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.IntentSender;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.ResolvableApiException;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.LocationSettingsRequest;
import com.google.android.gms.location.LocationSettingsResponse;
import com.google.android.gms.location.LocationSettingsStatusCodes;
import com.google.android.gms.tasks.Task;

import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

public class NearbyDiscoveryLocation implements PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {
  private Activity activity;

  private static final int LOCATION_ENABLE_REQUEST = 11;
  private static final int REQUEST_LOCATION_PERMISSION = 12;

  private LocationSettingsRequest mLocationSettingsRequest;
  private Result result;

  public NearbyDiscoveryLocation(@Nullable Activity activity) {
    this.setActivity(activity);
  }

  NearbyDiscoveryLocation() {
    this.activity = null;
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (result == null) return false;

    if (requestCode == LOCATION_ENABLE_REQUEST) {
      result.success(resultCode == Activity.RESULT_OK);
      result = null;
      return true;
    }

    return false;
  }

  @Override
  public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    if (requestCode == REQUEST_LOCATION_PERMISSION && permissions.length > 0) {

      if (result != null) {
        result.success(grantResults[0] == PackageManager.PERMISSION_GRANTED);
        result = null;
      }

      return true;
    }

    return false;
  }

  void setActivity(Activity activity) {
    this.activity = activity;
    initiateLocationServiceRequest();
  }

  private void initiateLocationServiceRequest() {
    LocationRequest mLocationRequest = LocationRequest.create();
    LocationSettingsRequest.Builder builder = new LocationSettingsRequest
      .Builder()
      .addLocationRequest(mLocationRequest)
      .setAlwaysShow(true);
    mLocationSettingsRequest = builder.build();
  }

  void requestLocationEnable(final Result result) {
    this.result = result;
    Task<LocationSettingsResponse> task = LocationServices.getSettingsClient(activity)
      .checkLocationSettings(mLocationSettingsRequest);

    task.addOnCompleteListener(task1 -> {
      try {
        task1.getResult(ApiException.class);
        result.success(true);
      } catch (ApiException ex) {
        switch (ex.getStatusCode()) {
          case LocationSettingsStatusCodes.SUCCESS:
            result.success(true);
            break;
          case LocationSettingsStatusCodes.RESOLUTION_REQUIRED:
            try {
              ResolvableApiException resolvableApiException =
                (ResolvableApiException) ex;
              resolvableApiException
                .startResolutionForResult(activity, LOCATION_ENABLE_REQUEST);
            } catch (IntentSender.SendIntentException e) {
              result.error("LOCATION_SERVICE_ERROR", e.getMessage(), null);
            }
            break;
          default:
            result.success(false);
        }
      }
    });
  }

  void requestLocationPermission(Result result) {
    this.result = result;

    ActivityCompat.requestPermissions(activity, new String[] {
      Manifest.permission.ACCESS_FINE_LOCATION,
      Manifest.permission.ACCESS_COARSE_LOCATION
    }, REQUEST_LOCATION_PERMISSION);
  }
}
