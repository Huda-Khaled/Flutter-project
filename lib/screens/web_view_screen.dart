import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hadi_apps/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/webview_prov.dart';
import 'main_nav_screen.dart';

// stelss
// stful
// ignore: use_key_in_widget_constructors
class WebViewScreen extends StatefulWidget {
  //هنا يتم وضع امر للانتقال الي الصفحة الرئيسية عند التواجد في احد الصفحات
  final VoidCallback onChangeNavigation;
  const WebViewScreen({required this.onChangeNavigation});
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late VoidCallback onChangeBackHome = widget.onChangeNavigation;
  BannerAd? _bannerAd;
  bool _isLoading = true;
  bool _isBack = false;
  bool _isLoadBanner = false;
  InterstitialAd? _interstitialAd;
  final adUnitIdBanner = Platform.isIOS ? '' : '';

  final adUnitIdInterstital = Platform.isIOS ? '' : '';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  WebViewController? ctrl;
  @override
  void initState() {
    Future.delayed(const Duration(microseconds: 100), () {
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "",
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            print('banner failed=>$error');
          },
          onAdLoaded: (ad) {
            setState(() {
              _isLoadBanner = true;
            });
          },
        ),
        request: const AdRequest(),
      );
      _bannerAd?.load();
      ctrl = Provider.of<WebviewProv>(context, listen: false).getWebViewCtrl();
      if (ctrl == null) {
        ctrl =
            WebViewController()
              ..loadRequest(Uri.parse('https://nafezly.com/'))
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageFinished: (finish) async {
                    InterstitialAd.load(
                      adUnitId: adUnitIdInterstital,
                      request: const AdRequest(),
                      adLoadCallback: InterstitialAdLoadCallback(
                        onAdLoaded: (InterstitialAd ad) {
                          _interstitialAd = ad;
                        },
                        onAdFailedToLoad: (LoadAdError error) {
                          print('InterstitialAd failed: $error');
                        },
                      ),
                    );
                    Timer.periodic(const Duration(seconds: 7), (timer) {
                      _interstitialAd?.show();
                    });
                    try {
                      if (((await Provider.of<WebviewProv>(
                            context,
                            listen: false,
                          ).webViewController?.canGoBack()) ??
                          false)) {
                        setState(() {
                          _isBack = true;
                        });
                      } else {
                        setState(() {
                          _isBack = false;
                        });
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    } catch (_) {}
                  },
                  onNavigationRequest: (NavigationRequest request) {
                    //
                    if (request.url.startsWith('https://nafezly.com/') ||
                        request.url.startsWith('https://static') ||
                        request.url.startsWith('https://nafezly.com/') ||
                        request.url.startsWith('https://c') ||
                        request.url.startsWith('https://') ||
                        request.url.startsWith('https://challenges') ||
                        request.url.startsWith('https://tr') ||
                        request.url.startsWith('https://p') ||
                        request.url.startsWith('challenges.cloudflare.com') ||
                        request.url.startsWith('https://s.salla')) {
                      return NavigationDecision.navigate;
                    } else {
                      _launchURL(request.url);
                      return NavigationDecision.prevent;
                    }
                  },
                ),
              )
              ..setJavaScriptMode(JavaScriptMode.unrestricted);

        Provider.of<WebviewProv>(context, listen: false).setWebViewCtrl(ctrl);
      } else {
        ctrl =
            Provider.of<WebviewProv>(context, listen: false).getWebViewCtrl();
        setState(() {
          _isLoading = false;
        });
        print('second time');
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<WebviewProv, WebViewController?>(
      selector: (_, prov) => prov.webViewController,
      builder: (_, ctrl, ___) {
        return Scaffold(
          key: _key,
          endDrawer: Drawer(
            width: 0,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            child: ListView(
              children: [
                // Image.network(
                //   'https://work-hadi.me/img-other/555.png',
                //   // width: 200,
                //   // height: 280,
                //   // fit: BoxFit.fill,
                // ),
                DrawerHeader(
                  // decoration: const BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("images/list.png"),
                  //     // alignment: Alignment.topCenter,
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('images/logo.png', height: 100),
                      const Text(
                        ' سطوع الشرق ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // const Divider(color: Color(0xFF698AD9)),
                ListTile(
                  trailing: const Icon(
                    Icons.pentagon,
                    size: 17,
                    color: Color(0xFF1a8c96),
                  ),
                  title: const Text(
                    'الصفحة الرئيسية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    if (ctrl != null) {
                      ctrl.loadRequest(
                        Uri.parse('https://www.freelancer.com/'),
                      );
                    }

                    onChangeBackHome();
                    Navigator.pop(context);
                  },
                ),

                const Divider(color: Colors.grey),

                // Divider(),

                // ListTile(
                //     trailing: const Icon(
                //       Icons.social_distance_outlined,
                //       size: 19,
                //       color: Color(0xFF046fa3),
                //     ),
                //     title: const Text(
                //       'نقل خدمات',
                //       textAlign: TextAlign.right,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 18),
                //     ),
                //     onTap: () {
                //       ctrl?.loadRequest(
                //         Uri.parse(
                //             'https://www.freelancer.com/'),
                //       );
                //       Navigator.pop(context);
                //     }),

                // // Divider(),
                // ListTile(
                //     trailing: const Icon(
                //       Icons.rate_review_outlined,
                //       size: 19,
                //       color: Color(0xFF046fa3),
                //     ),
                //     title: const Text(
                //       'التأجير',
                //       textAlign: TextAlign.right,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 18),
                //     ),
                //     onTap: () {
                //       ctrl?.loadRequest(
                //         Uri.parse(
                //             'https://www.freelancer.com/'),
                //       );
                //       Navigator.pop(context);
                //     }),
                // // Divider(),
                // ListTile(
                //     trailing: const Icon(
                //       Icons.style,
                //       size: 19,
                //       color: Color(0xFF046fa3),
                //     ),
                //     title: const Text(
                //       'عروضنا',
                //       textAlign: TextAlign.right,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 18),
                //     ),
                //     onTap: () {
                //       ctrl?.loadRequest(
                //         Uri.parse(
                //             'https://www.freelancer.com/'),
                //       );
                //       Navigator.pop(context);
                //     }),
                ListTile(
                  trailing: const Icon(
                    Icons.reply_outlined,
                    size: 17,
                    color: Color(0xFF1a8c96),
                  ),
                  title: const Text(
                    'مشاركة التطبيق',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  onTap: () {
                    Share.share(
                      sharePositionOrigin: Rect.fromLTWH(300, 300, 200, 300),
                      'قم بتحميل تطبيق  سطوع الشرق الرابط https://www.freelancer.com/',
                      subject: ' قم بتحميل تطبيق سطوع الشرق',
                    );

                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  trailing: const Icon(
                    Icons.error,
                    size: 17,
                    color: Color(0xFF1a8c96),
                  ),
                  title: const Text(
                    'عن التطبيق',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  onTap: () {
                    ctrl?.loadRequest(Uri.parse('https://www.freelancer.com/'));
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.grey),
                // Divider(),
                ListTile(
                  trailing: const Icon(
                    Icons.gpp_maybe_outlined,
                    size: 17,
                    color: Color(0xFF1a8c96),
                  ),
                  title: const Text(
                    ' سياسة الخصوصية',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  onTap: () {
                    ctrl?.loadRequest(Uri.parse('https://www.freelancer.com/'));
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.grey),
                _isLoadBanner == true
                    ? SizedBox(
                      height: 0,
                      width: 0,
                      child: AdWidget(ad: _bannerAd!),
                    )
                    : SizedBox(
                      height: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          CircularProgressIndicator(),
                        ],
                      ),
                    ),
                const Divider(color: Color.fromARGB(255, 255, 255, 255)),
                Text(
                  'جميع الحقوق محفوظة   ',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Hadi Asiri © تطوير',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            leadingWidth: 100,
            actionsIconTheme: const IconThemeData(
              color: Color(0xFF1a8c96),
              size: 35,
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _key.currentState!.openEndDrawer();
                },
                icon: const Icon(Icons.menu),
              ),
            ],
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    ctrl?.loadRequest(Uri.parse('https://nafezly.com/'));
                  },
                  icon: const Icon(Icons.telegram, color: Color(0xFF1a8c96)),
                  iconSize: 35,
                ),
                // IconButton(
                //   onPressed: () {
                //     ctrl?.loadRequest(Uri.parse(
                //         'https://www.freelancer.com/'));
                //   },
                //   icon: const Icon(
                //     Icons.circle_notifications,
                //     color: Color(0xFF046fa3),
                //   ),
                //   iconSize: 35,
                // ),
              ],
            ),

            centerTitle: true,

            toolbarHeight: 0,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            //هنا صورة اللوقو اعلى التطبيق
            title: Image.asset('images/l.png', width: 100, height: 60),
          ),
          body:
              (_isLoading || ctrl == null) ||
                      (connectionStatus == ConnectivityResult.none)
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(color: Color(0xFF3C79EC)),

                        SizedBox(height: 50),
                        Text(
                          ' ... جاري تحميل الصفحة ',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF046fa3),
                            fontWeight: FontWeight.bold,
                          ),
                          // Image(
                          //   image: AssetImage('images/2.gif'),
                          // height: 985,
                          // width: 644,
                          // fit: BoxFit.cover,
                        ),
                        //   )
                        // ],
                        // ))
                      ],
                    ),
                  )
                  : WebViewWidget(controller: ctrl),
        );
      },
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
