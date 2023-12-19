import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:minggu_13/main_screen.dart';

AppOpenAd? appOpenAd;
loadAppOpenAd() {
  AppOpenAd.load(
    adUnitId: Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-3940256099942544/5575463023', 
    request: const AdRequest(), 
    adLoadCallback: AppOpenAdLoadCallback(
      onAdLoaded: (ad) {
        appOpenAd = ad;
        appOpenAd!.show();
      }, 
      onAdFailedToLoad: (err) {
        print(err);
      }
    ), 
    orientation: AppOpenAd.orientationPortrait
  );
}
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  loadAppOpenAd();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}