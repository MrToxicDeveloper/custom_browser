import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HomeProvider extends ChangeNotifier{

  InAppWebViewController? inAppWebViewController;
  PullToRefreshController pullToRefreshController = PullToRefreshController();

  // bool? prog;

  double progressIndicator = 0;

  void changeProgress(double progress){
    progressIndicator = progress;
    notifyListeners();
    // progressIndicator = 0;
  }
}
