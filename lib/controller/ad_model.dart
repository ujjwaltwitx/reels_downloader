// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdServices {
//   static BannerAd? ad;
//   static void createBannerAd() {
//     ad = BannerAd(
//       size: AdSize.banner,
//       adUnitId: 'ca-app-pub-1332264183046401/9389328021',
//       listener: const BannerAdListener(),
//       request: const AdRequest(),
//     );
//     ad!.load();
//   }

  // static Future<void> createRewardedAd() async {
  //   await RewardedAd.load(
  //     adUnitId: 'ca-app-pub-1332264183046401/9886848014',
  //     request: const AdRequest(),
  //     rewardedAdLoadCallback: RewardedAdLoadCallback(
  //       onAdLoaded: (RewardedAd ad) {
  //         // rewardedAd = ad;
  //       },
  //       onAdFailedToLoad: (LoadAdError error) {},
  //     ),
  //   );
  // }

  // static Future<void> showRewardedAd() async {
  //   // await rewardedAd.show(
  //   //     onUserEarnedReward: (RewardedAd ad, RewardItem reward) {});
  // }
// }
