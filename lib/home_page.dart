import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:speed_stellantis/config/speed_colors.dart';
import 'package:speed_stellantis/widgets_utils/circular_progress_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  InAppWebViewController? _webViewController;
  String url = "";
  double progress = 0;
  bool loadInitial = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: exit,
      child: Scaffold(
        backgroundColor: SpeedColors.primary,
        body: SafeArea(
          child: SizedBox(
            child: Stack(
              children: <Widget>[
                // progress < 1.0 ? Container(
                //     padding: const EdgeInsets.all(10.0),
                //     child: LinearProgressIndicator(value: progress))
                //     : Container(),
                Opacity(
                  opacity: (progress < 1.0 && !loadInitial) ? 0 : 1,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(url: Uri(path: "www.speed-stellantis.es/")),
                      initialOptions: InAppWebViewGroupOptions(
                          android: AndroidInAppWebViewOptions()
                      ),
                      onWebViewCreated: (InAppWebViewController controller) {
                        _webViewController = controller;
                      },
                      onLoadStart: (InAppWebViewController controller, Uri? url) {
                        setState(() {
                          this.url = url!.path;
                        });
                      },
                      onLoadStop: (InAppWebViewController controller, Uri? url) async {
                        setState(() {
                          this.url = url!.path;
                        });
                      },
                      onProgressChanged: (InAppWebViewController controller, int progress) {
                        setState(() {
                          this.progress = progress / 100;
                          if(this.progress == 1){
                            loadInitial = true;
                          }
                        });
                      },

                    ),
                  ),
                ),
                if(progress < 1.0)...[
                  Center(
                    child: circularProgressColors(colorCircular: loadInitial ? SpeedColors.primary : Colors.white,widthContainer1: 30,widthContainer2: 30),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<bool> exit() async {
    if (_webViewController != null) {
      if (await _webViewController!.canGoBack()) {
        WebHistory? webHistory = await _webViewController!.getCopyBackForwardList();
        if (webHistory != null && webHistory.currentIndex! <= 0) {
          return false;
        }
        _webViewController!.goBack();
        return false;
      }
    }
    return false;
  }
}
