package com.mavyfaby.nearby_discovery;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.LocationManager;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import com.google.android.gms.nearby.Nearby;
import com.google.android.gms.nearby.connection.DiscoveredEndpointInfo;
import com.google.android.gms.nearby.connection.DiscoveryOptions;
import com.google.android.gms.nearby.connection.EndpointDiscoveryCallback;
import com.google.android.gms.nearby.connection.Strategy;
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

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class NearbyDiscovery {
    private static final int LOCATION_ENABLE_REQUEST = 777;
    private static final int REQUEST_LOCATION_PERMISSION = 7777;

    /**
     * Check if location permission is granted
     * @param context Context of the application
     * @param result Result
     */
    public static void isLocationPermissionGranted(@NonNull Context context, @NonNull Result result) {
        // Check if location permission is granted
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            // Send true
            result.success(true);
        } else {
            // Send false
            result.success(false);
        }
    }

    /**
     * Check if location is enabled
     * @param context Context of the application
     * @param result Result
     */
    public static void isLocationEnabled(@NonNull Context context, @NonNull Result result) {
        LocationManager lm = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);

        boolean isGPSEnabled = false;
        boolean isNetworkEnabled = false;

        try {
            isGPSEnabled = lm.isProviderEnabled(LocationManager.GPS_PROVIDER);
        } catch (Exception ignored) {
        }

        try {
            isNetworkEnabled = lm.isProviderEnabled(LocationManager.NETWORK_PROVIDER);
        } catch (Exception ignored) {
        }

        // Send result
        result.success(isGPSEnabled || isNetworkEnabled);
    }

    /**
     * Request location permission
     * @param location Nearby Discovery Location
     * @param result Result
     */
    public static void requestLocationPermission(NearbyDiscoveryLocation location, @NonNull Result result) {
        // Request location permission
        location.requestLocationPermission(result);
    }

    /**
     * Request location enable
     * @param location Nearby Discovery Location
     * @param result Result
     */
    public static void requestLocationEnable(NearbyDiscoveryLocation location, @NonNull Result result) {
        // Request location enable
        location.requestLocationEnable(result);
    }

    /**
     * Start Discovery
     *
     * @param context Context of the application
     * @param call Method call
     * @param result Result
     */
    public static void startDiscovery(MethodChannel channel, @NonNull Context context, @NonNull MethodCall call, @NonNull Result result) {
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

        // Start discovery
        Nearby.getConnectionsClient(context)
            .startDiscovery(serviceID, new EndpointDiscoveryCallback() {
                /**
                 * On endpoint found
                 * @param endpointId Endpoint id
                 * @param discoveredEndpointInfo Discovered endpoint info
                 */
                @Override
                public void onEndpointFound(@NonNull String endpointId,
                                            @NonNull DiscoveredEndpointInfo discoveredEndpointInfo) {
                    Map<String, Object> args = new HashMap<>();
                    args.put("endpointId", endpointId);
                    args.put("endpointName", discoveredEndpointInfo.getEndpointName());
                    args.put("serviceId", discoveredEndpointInfo.getServiceId());

                    // Send endpoint found
                    channel.invokeMethod("endpoint_found", args);
                }

                /**
                 * On endpoint lost
                 * @param endpointId Endpoint id
                 */
                @Override
                public void onEndpointLost(@NonNull String endpointId) {
                    Map<String, Object> args = new HashMap<>();
                    args.put("endpointId", endpointId);

                    // Send endpoint lost
                    channel.invokeMethod("endpoint_lost", args);
                }
            }, discoveryOptions)
            .addOnSuccessListener((Void unused) -> {
                // We're discovering!
                result.success(true);
              })
            .addOnFailureListener((Exception e) -> {
                // We're unable to start discovering.
                result.error("4", "Unable to start discovering", null);
            });
    }

    /**
     * Stop Discovery
     */
    public static void stopDiscovery(@NonNull Context context, @NonNull Result result) {
        Nearby.getConnectionsClient(context).stopDiscovery();
        result.success(true);
    }

    /**
     * Get Nearby Connection Strategy
     */
    private static Strategy getStrategy(int strategy) {
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
