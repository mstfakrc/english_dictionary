import 'package:dictionaryenglish/widgets/bottomNavigationBar.dart';
import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:dictionaryenglish/pages/learnPage.dart';
import 'package:dictionaryenglish/pages/listWordPage.dart';
import 'package:dictionaryenglish/pages/searchPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeUnityAds();
  runApp(MyApp());
}

// Initialize Unity Ads
Future<void> _initializeUnityAds() async {
  await UnityAds.init(
    gameId: "5526719", // Replace with your Unity Ads Game ID
    testMode: false,
    onComplete: () {
      print('Unity Ads Initialization Complete');
    },
    onFailed: (error, message) {
      print('Unity Ads Initialization Failed: $error $message');
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary App',
      initialRoute: "bottomNav",
      routes: _appRoutes(),
    );
  }

  // App routes definition
  Map<String, WidgetBuilder> _appRoutes() {
    return {
      "learnPage": (BuildContext context) => LearnPage(),
      "listWordPage": (BuildContext context) => ListWordPage(),
      "searchPage": (BuildContext context) => SearchPage(),
      "bottomNav": (BuildContext context) => BottomNavigationBarWidget(),
    };
  }
}
