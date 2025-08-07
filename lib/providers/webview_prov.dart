import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewProv with ChangeNotifier {
  WebViewController? webViewController,
      webViewControllerCopy,
      webViewControllerCopyy,
      webViewControllerCopyyy,
      webViewControllerCopyyyy;

  WebViewController? getWebViewCtrl() {
    return webViewController;
  }

  WebViewController? getWebViewCtrlCopy() {
    return webViewControllerCopy;
  }

  WebViewController? getWebViewCtrlCopyy() {
    return webViewControllerCopyy;
  }

  WebViewController? getWebViewCtrlCopyyy() {
    return webViewControllerCopyyy;
  }

  WebViewController? getWebViewCtrlCopyyyy() {
    return webViewControllerCopyyyy;
  }

  setWebViewCtrl(WebViewController? ctrl) {
    webViewController = ctrl;
    notifyListeners();
  }

  setWebViewCtrlCopy(WebViewController? ctrl) {
    webViewControllerCopy = ctrl;
    notifyListeners();
  }

  setWebViewCtrlCopyy(WebViewController? ctrl) {
    webViewControllerCopyy = ctrl;
    notifyListeners();
  }

  setWebViewCtrlCopyyy(WebViewController? ctrl) {
    webViewControllerCopyyy = ctrl;
    notifyListeners();
  }

  setWebViewCtrlCopyyyy(WebViewController? ctrl) {
    webViewControllerCopyyyy = ctrl;
    notifyListeners();
  }

  resetCtrl() {
    webViewController?.loadRequest(Uri.parse(''));
  }

  resetCtrlCopy() {
    webViewControllerCopy?.loadRequest(Uri.parse(''));
  }

  resetCtrlCopyy() {
    webViewControllerCopyy?.loadRequest(Uri.parse(''));
  }

  resetCtrlCopyyy() {
    webViewControllerCopyyy?.loadRequest(Uri.parse(''));
  }

  resetCtrlCopyyyy() {
    webViewControllerCopyyyy?.loadRequest(Uri.parse(''));
  }
}
