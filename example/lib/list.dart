import 'package:flutter/material.dart';
import 'package:nearby_discovery/nearby_discovery.dart';

class MyList extends StatefulWidget {
  const MyList({super.key});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  List<NearbyDevice> devices = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("This will show a list of found nearby devices."),
    );
  }
}
