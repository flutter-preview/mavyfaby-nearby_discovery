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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.tonal(
                onPressed: () async {
                  await nearby.startDiscovery("service", "test", NearbyStrategy.cluster);
                },
                child: const Text("Start Discovery")
              ),
              FilledButton.tonal(
                onPressed: () async {
                  await nearby.stopDiscovery();
                },
                child: const Text("Stop Discovery")
              )
            ],
          ),
        ),
      ),
    );
  }
}
