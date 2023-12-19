import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int coin = 0;
  late BannerAd _bannerAd;
  bool _isBannerReady = false;

  late InterstitialAd _interstitialAd;
  bool _isInterstitialReady = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedReady = false;

  bool _showAd = true;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AdMob')),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    size: 50,
                  ),
                  Text(
                    coin.toString(),
                    style: const TextStyle(fontSize: 50),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_showAd == true) {
                    _loadInterstisialAd();
                    if (_isInterstitialReady) {
                      _interstitialAd.show();
                    }
                  }
                },
                child: const Text('Interstitial Ads'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_showAd == true) {
                    _loadRewardedAd();
                    if (_isRewardedReady) {
                      _rewardedAd.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                        setState(() {
                          coin += 1;
                        });
                      });
                    }
                  }
                },
                child: const Text('Rewarded Ads'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Ad '),
                  Switch(
                    value: _showAd,
                    onChanged: (value) {
                      setState(() {
                        _showAd = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_showAd)
              Expanded(
                child: _isBannerReady
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: _bannerAd.size.width.toDouble(),
                        height: _bannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd),
                      ),
                    )
                  : Container()
              ),
          ],
        ),
      ),
    );
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerReady = true;
          });
        }, onAdFailedToLoad: (ad, err) {
          _isBannerReady = false;
          ad.dispose();
        }),
        request: const AdRequest());
    _bannerAd.load();
  }

  void _loadInterstisialAd() {
    InterstitialAd.load(
    adUnitId: "ca-app-pub-3940256099942544/1033173712",
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
      ad.fullScreenContentCallback = FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        print("Close Interstitial Ad");
      });
      setState(() {
        _isInterstitialReady = true;
        _interstitialAd = ad;
      });
      }, onAdFailedToLoad: (err) {
        _isInterstitialReady = false;
        _interstitialAd.dispose();
      })
    );
  }
  
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: "ca-app-pub-3940256099942544/5224354917", 
      request: const AdRequest(), 
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _isRewardedReady = false;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _isRewardedReady = true;
            _rewardedAd = ad;
          });
        }, 
        onAdFailedToLoad: (err) {
          _isRewardedReady = false;
          _rewardedAd.dispose();
        }
      )
    );
  }
}