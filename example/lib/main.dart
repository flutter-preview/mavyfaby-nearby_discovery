import 'package:flutter/material.dart';
import 'package:nearby_discovery/nearby_discovery.dart';

import 'home.dart';
import 'list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NearbyDiscovery.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController pageController = PageController();
  int index = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(
        useMaterial3: true
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Nearby Discovery ${index == 0 ? "Example" : "List"}"),
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: (int index) {
            setState(() {
              this.index = index;
            });
          },
          children: const [
            MyHome(),
            MyList()
          ],
        ),
        bottomNavigationBar: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            NavigationDestination(
              icon: Icon(Icons.list),
              label: "List"
            )
          ],
          selectedIndex: index,
          onDestinationSelected: (int index) {
            pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
            setState(() {
              this.index = index;
            });
          },
        ),
      )
    );
  }
}

