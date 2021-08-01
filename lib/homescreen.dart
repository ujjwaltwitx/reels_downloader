import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'adservices.dart';
import 'download_services.dart';

final percentageProvider = ChangeNotifierProvider<DownloadServices>((ref) {
  return DownloadServices();
});

class HomeScreen extends ConsumerWidget {
  final TextEditingController textValue = TextEditingController();
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final percentage = watch(percentageProvider);
    if (percentage.copyText == true) {
      textValue.text = percentage.copyValue;
      percentage.copyText = false;
    }

    final height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        AppBar().preferredSize.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.pink[400],
        title: const Text('ReelsSaver' + '	🤫'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: Chip(
              labelPadding: const EdgeInsets.all(2.0),
              avatar: CircleAvatar(
                child: SvgPicture.asset("assets/bitmap2.svg"),
              ),
              label: Text(
                ' ${percentage.coin}',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.black,
              elevation: 6.0,
              shadowColor: Colors.pink[300],
              padding: const EdgeInsets.all(8.0),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: height * 0.1,
            width: double.infinity,
            margin:
                const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
            child: TextField(
              style: const TextStyle(color: Colors.pink),
              cursorColor: Colors.pink,
              controller: textValue,
              decoration: const InputDecoration(
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pink)),
                  border: OutlineInputBorder(),
                  labelText: ' Enter Url',
                  hintText: 'Enter Url'),
            ),
          ),
          SizedBox(
            height: height * 0.06,
            // ignore: deprecated_member_use
            child: RaisedButton(
              onPressed: () async {
                DownloadServices.instance.downloadReels(textValue.text);
                await Future.delayed(const Duration(seconds: 3));
                if (AdServices.rewardedAd == null) {
                  AdServices.createRewardedAd();
                }
                AdServices.showRewardedAd();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pink, Colors.red[300]],
                    ),
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 300.0,
                    minHeight: height * 0.06,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${percentage.downVar} ${percentage.percentage.toString()}%",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          SizedBox(
            height: height * 0.4,
            child: AdWidget(ad: AdServices.createBannerAd()..load()),
          ),
          Container(
            width: double.infinity,
            height: height * 0.3,
            margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: const AutoSizeText(
                "We understand the problems you face because of ads but, as startup we need funds to keep our business up and running. Hope you as a user will understand. The Coins system is an experimental feature which will be rolled out as an update in near future."),
          )
        ],
      ),
    );
  }
}
