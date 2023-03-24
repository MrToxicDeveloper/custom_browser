import 'package:custom_browser/home_screen/provider/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController txtsearch = TextEditingController();

  HomeProvider? homeProviderTrue;
  HomeProvider? homeProviderFalse;

  @override
  void initState() {
    super.initState();

    homeProviderFalse!.pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        homeProviderFalse!.inAppWebViewController?.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    homeProviderTrue = Provider.of<HomeProvider>(context, listen: true);
    homeProviderFalse = Provider.of<HomeProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                // borderRadius: BorderRadius.all(
                //   Radius.circular(10),
                // ),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.white38,
                //       blurRadius: 2,
                //       spreadRadius: 2,
                //     ),
                //   ],
              ),
              // margin: EdgeInsets.all(15),
              // padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      homeProviderFalse!.inAppWebViewController?.loadUrl(
                        urlRequest: URLRequest(
                            url: Uri.parse("https://www.google.com/")),
                      );
                    },
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.white,
                      controller: txtsearch,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: IconButton(
                          onPressed: () {
                            var newLink = txtsearch.text;

                            homeProviderTrue!.inAppWebViewController?.loadUrl(
                              urlRequest: URLRequest(
                                url: Uri.parse(
                                    "https://www.google.com/search?q=$newLink"),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.search_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        hintText: "search",
                        hintStyle: TextStyle(
                          color: Colors.white60,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      homeProviderFalse!.inAppWebViewController?.goBack();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      homeProviderFalse!.inAppWebViewController?.reload();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      homeProviderFalse!.inAppWebViewController?.goForward();
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            // Visibility(
            //   visible: homeProviderTrue!.progressIndicator == 0
            //         ? homeProviderTrue!.prog = true
            //         : homeProviderTrue!.prog = false,
            LinearProgressIndicator(
              value: homeProviderTrue!.progressIndicator,
            ),
            // ),

            Expanded(
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: Uri.parse("https://www.google.com/")),
                pullToRefreshController: homeProviderFalse!.pullToRefreshController,
                onProgressChanged: (controller, progress) {
                  homeProviderFalse!.inAppWebViewController = controller;
                  if(progress == 100){
                    homeProviderFalse!.pullToRefreshController.endRefreshing();
                  }
                  homeProviderFalse!.changeProgress(progress / 100);
                  // homeProviderFalse!.progressIndicator = 0;
                },
                onLoadError: (controller, url, code, message) {
                  homeProviderFalse!.pullToRefreshController.endRefreshing();

                  homeProviderFalse!.inAppWebViewController = controller;
                },
                onLoadStart: (controller, url) {
                  homeProviderFalse!.inAppWebViewController = controller;
                },
                onLoadStop: (controller, url) {
                  homeProviderFalse!.pullToRefreshController.endRefreshing();

                  homeProviderFalse!.inAppWebViewController = controller;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
