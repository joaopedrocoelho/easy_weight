import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId => Platform.isIOS  ? 'ca-app-pub-3940256099942544/2934735716' 
  : 'ca-app-pub-3940256099942544/6300978111';

  BannerAdListener get bannerAdListener => _bannerAdListener;

  BannerAdListener _bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) {
      print("$ad loaded, ${ad.adUnitId}");
    },
    onAdOpened: (ad) {
      print("$ad opened, ${ad.adUnitId}");
    }
  );
}