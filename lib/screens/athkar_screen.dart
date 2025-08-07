import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';

// stelss
// stful
// ignore: use_key_in_widget_constructors
class AthkarViewScreen extends StatefulWidget {
  @override
  State<AthkarViewScreen> createState() => _AthkarViewScreenState();
}

class _AthkarViewScreenState extends State<AthkarViewScreen> {
  WebViewController? _webViewController;
  bool _isLoading = true;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    _webViewController = WebViewController()
      ..loadRequest(
        Uri.parse('https://athkar.co'),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith("https://athkar.co")) {
              return NavigationDecision.navigate;
            } else {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
          },
          onPageStarted: (url) {},
          onPageFinished: (finish) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        actionsIconTheme: const IconThemeData(color: Colors.green, size: 40),
        leading: IconButton(
          onPressed: () {
            _webViewController!.goBack();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          iconSize: 40,
        ),
        centerTitle: true,
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 49, 109, 206),
        elevation: 0,
        title: Image.asset(
          'images/logo.png',
          width: 50,
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'LOADING..',
                  style: TextStyle(fontSize: 30),
                )
              ],
            ))
          : WebViewWidget(
              controller: _webViewController!,
            ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
