import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: avoid_classes_with_only_static_members
class AdServices {
  // static RewardedAd rewardedAd;
  static void initialize() {
    if (MobileAds.instance == null) {
      MobileAds.instance.initialize();
      createRewardedAd();
    }
  }

  static BannerAd createBannerAd() {
    final BannerAd ad = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: 'ca-app-pub-1332264183046401/9389328021',
      listener: const BannerAdListener(),
      request: const AdRequest(),
    );
    return ad;
  }

  static Future<void> createRewardedAd() async {
    await RewardedAd.load(
      adUnitId: 'ca-app-pub-1332264183046401/9886848014',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          // rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {},
      ),
    );
  }

  static Future<void> showRewardedAd() async {
    // await rewardedAd.show(
    //     onUserEarnedReward: (RewardedAd ad, RewardItem reward) {});
  }
}
