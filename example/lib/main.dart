import 'package:flutter/material.dart';
import 'package:nearby_discovery/nearby_discovery.dart';

NearbyDiscovery nearby = NearbyDiscovery();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLocationPermissionGranted = false;
  bool isLocationEnabled = false;
  bool isDiscoveryStarted = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // Check if location permission is granted
    nearby.isLocationPermissionGranted().then((value) {
      setState(() {
        isLocationPermissionGranted = value != null ? value! : false;
      });
    });

    // Check if location is enabled
    nearby.isLocationEnabled().then((value) {
      setState(() {
        isLocationEnabled = value != null ? value! : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('NearbyDiscovery Example'),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Location Permission: ", style: TextStyle(letterSpacing: 0, fontSize: 14)),
                        Text(isLocationPermissionGranted ? 'Granted' : 'Not Granted', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: isLocationPermissionGranted ? Colors.green : Colors.red
                        )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Location Enabled: ", style: TextStyle(letterSpacing: 0, fontSize: 14)),
                        Text(isLocationEnabled ? 'Enabled' : 'Not Enabled', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: isLocationEnabled ? Colors.green : Colors.red
                        )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Is Discovery Started: ", style: TextStyle(letterSpacing: 0, fontSize: 14)),
                        Text(isDiscoveryStarted ? 'Started' : 'Not Started', style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: isDiscoveryStarted ? Colors.green : Colors.red
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 64),
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        direction: Axis.vertical,
                        children: [
                          FilledButton(
                              onPressed: () async {
                                NearbyResult result = await nearby.startDiscovery("service", "test", NearbyStrategy.cluster);

                                if (result == NearbyResult.success) {
                                  setState(() {
                                    isDiscoveryStarted = true;
                                    isLocationEnabled = true;
                                    isLocationPermissionGranted = true;
                                  });

                                  return;
                                }

                                setState(() {
                                  isDiscoveryStarted = false;
                                });

                                if (result == NearbyResult.locationPermissionNotGranted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Failed: Location Permission Not Granted"),
                                      behavior: SnackBarBehavior.floating,
                                    )
                                  );

                                  setState(() {
                                    isLocationPermissionGranted = false;
                                  });

                                  return;
                                }

                                if (result == NearbyResult.locationNotEnabled) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Failed: Location Not Enabled"),
                                        behavior: SnackBarBehavior.floating,
                                      )
                                  );

                                  setState(() {
                                    isLocationEnabled = false;
                                  });

                                  return;
                                }
                              },
                              child: const Text("Start Discovery")
                          ),
                          FilledButton.tonal(
                              onPressed: () async {
                                bool? result = await nearby.stopDiscovery();

                                if (result) {
                                  setState(() {
                                    isDiscoveryStarted = false;
                                  });
                                }
                              },
                              child: const Text("Stop Discovery")
                          ),
                          FilledButton.tonal(
                            onPressed: () async {
                              bool? result = await NearbyDiscovery.requestLocationPermission();
                              
                              setState(() {
                                isLocationPermissionGranted = result;
                              });
                            },
                            child: const Text("Request Location Permission")
                          ),
                          FilledButton.tonal(
                            onPressed: () async {
                              bool? result = await NearbyDiscovery.requestLocationEnable();

                              setState(() {
                                isLocationEnabled = result;
                              });
                            },
                            child: const Text("Request Location Enable")
                          )
                        ],
                      ),
                    )
                  ],
                )
            ),
          );
        },
      )
    );
  }
}
