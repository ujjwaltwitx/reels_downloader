import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'download_services.dart';

void main() {
  runApp(ProviderScope(child: HomeScreen()));
}

final percentageProvider = ChangeNotifierProvider<DownloadServices>((ref) {
  return DownloadServices();
});

class HomeScreen extends ConsumerWidget {
  final TextEditingController textValue = TextEditingController();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final percentage = watch(percentageProvider);
    textValue.text = percentage.copyValue;
    return MaterialApp(
      home: Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.pink[400],
          title: new Text('Reels Saver' + '	🤫'),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
              child: TextField(
                style: TextStyle(color: Colors.pink),
                cursorColor: Colors.pink,
                controller: textValue,
                decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink)),
                    border: OutlineInputBorder(),
                    labelText: ' Enter Url',
                    hintText: 'Enter Url'),
                maxLines: 1,
              ),
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey,
                  ),
                )
              ],
            ),
            Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  percentage.downloadReels(textValue.text);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.pink, Colors.red[300]],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "${percentage.downVar} ${percentage.percentage.toString()}%",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
