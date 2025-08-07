import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hadi_apps/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../providers/webview_prov.dart';
import 'main_nav_screen.dart';

// stelss
// stful
// ignore: use_key_in_widget_constructors
class WebViewScreencopyyy extends StatefulWidget {
  final VoidCallback onChangeNavigation;
  const WebViewScreencopyyy({required this.onChangeNavigation});
  @override
  State<WebViewScreencopyyy> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreencopyyy> {
  late VoidCallback onChangeBackHome = widget.onChangeNavigation;

  BannerAd? _bannerAd;
  bool _isLoading = true;
  bool _isBack = false;
  bool _isLoadBanner = false;
  InterstitialAd? _interstitialAd;
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
      ctrl =
          Provider.of<WebviewProv>(
            context,
            listen: false,
          ).getWebViewCtrlCopyyy();
      if (ctrl == null) {
        ctrl =
            WebViewController()
              ..loadRequest(Uri.parse('https://nafezly.com/'))
              ..setNavigationDelegate(
                NavigationDelegate(
                  onPageFinished: (finish) async {
                    InterstitialAd.load(
                      adUnitId: "",
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
                    Timer.periodic(const Duration(seconds: 15), (timer) {
                      _interstitialAd?.show();
                    });
                    try {
                      if (((await Provider.of<WebviewProv>(
                            context,
                            listen: false,
                          ).webViewControllerCopy?.canGoBack()) ??
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

        Provider.of<WebviewProv>(
          context,
          listen: false,
        ).setWebViewCtrlCopyyy(ctrl);
      } else {
        ctrl =
            Provider.of<WebviewProv>(
              context,
              listen: false,
            ).getWebViewCtrlCopyyy();
        setState(() {
          _isLoading = false;
        });
        print('second time for  menu ');
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
  @override
  Widget build(BuildContext context) {
    return Selector<WebviewProv, WebViewController?>(
      selector: (_, prov) => prov.webViewControllerCopyyy,
      builder: (_, ctrl, ___) {
        return Scaffold(
          key: _key,
          endDrawer: Drawer(
            width: 0,
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: Color(0xFFFCFCFC)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset('images/s.png', height: 100),
                      const Text(
                        ':) مــتــجــركـ تسوق ممتع ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  trailing: const Icon(Icons.home, color: Color(0xFF046fa3)),
                  title: const Text(
                    'الصفحة الرئيسية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () {
                    if (ctrl != null) {
                      ctrl.loadRequest(
                        Uri.parse('https://www.freelancer.com/'),
                      );
                    }
                    // هنا امر الانتقال لصفحة الرئيسية في الصفحات
                    onChangeBackHome();
                    Navigator.pop(context);
                  },
                ),
                // const Divider(color: Colors.grey),
                // ListTile(
                //     trailing: const Icon(
                //       Icons.account_circle,
                //       color: Color(0xFF046fa3),
                //     ),
                //     title: const Text(
                //       'حسابي',
                //       textAlign: TextAlign.right,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 20),
                //     ),
                //     onTap: () {
                //       ctrl?.loadRequest(
                //         Uri.parse(
                //             'https://www.freelancer.com/'),
                //       );
                //       Navigator.pop(context);
                //     }),
                // const Divider(color: Colors.grey),
                // ListTile(
                //     trailing: const Icon(
                //       Icons.circle_notifications,
                //       color: Color(0xFF046fa3),
                //     ),
                //     title: const Text(
                //       'الاشعارات',
                //       textAlign: TextAlign.right,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 20),
                //     ),
                //     onTap: () {
                //       ctrl?.loadRequest(
                //         Uri.parse(
                //             'https://www.freelancer.com/'),
                //       );
                //       Navigator.pop(context);
                //     }),
                // const Divider(color: Colors.grey),
                // ListTile(
                //     trailing: const Icon(
                //       Icons.circle_notifications_rounded,
                //       color: Color(0xFF046fa3),
                //     ),
                //     title: const Text(
                //       'الاشعارات',
                //       textAlign: TextAlign.right,
                //       style: TextStyle(
                //           fontWeight: FontWeight.bold, fontSize: 20),
                //     ),
                //     onTap: () {
                //       ctrl?.loadRequest(
                //         Uri.parse(
                //             'https://www.freelancer.com/'),
                //       );
                //       Navigator.pop(context);
                //     }),
                const Divider(color: Color(0xFF9E9E9E)),
                ListTile(
                  trailing: const Icon(Icons.info, color: Color(0xFF046fa3)),
                  title: const Text(
                    'عن المتجر',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onTap: () {
                    ctrl?.loadRequest(Uri.parse('https://www.freelancer.com/'));
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  trailing: const Icon(
                    Icons.privacy_tip_sharp,
                    color: Color(0xFF046fa3),
                  ),
                  title: const Text(
                    ' سياسة الخصوصية',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onTap: () {
                    ctrl?.loadRequest(Uri.parse('https://www.freelancer.com/'));
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  trailing: const Icon(Icons.share, color: Color(0xFF046fa3)),
                  title: const Text(
                    'مشاركة التطبيق',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onTap: () {
                    Share.share(
                      //هنا امر المشاركة للايباد ضروري وضعه
                      sharePositionOrigin: Rect.fromLTWH(300, 300, 200, 300),
                      '    حمل تطبيق سطوع الشرق من الرابط   https://www.freelancer.com/',
                      subject: ' تطبيق سطوع الشرق   ',
                    );
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  trailing: const Icon(Icons.reviews, color: Color(0xFF046fa3)),
                  title: const Text(
                    ' تقييم المتجر  ',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onTap: () {
                    ctrl?.loadRequest(Uri.parse('https://www.freelancer.com/'));
                    Navigator.pop(context);
                  },
                ),
                const Divider(color: Colors.grey),
                ListTile(
                  trailing: const Icon(Icons.wechat, color: Color(0xFF046fa3)),
                  title: const Text(
                    'تواصل معنا',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                Text(
                  'جميع الحقوق محفوظة لتطبيق سطوع الشرق',
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
            leadingWidth: 150,
            actionsIconTheme: const IconThemeData(
              color: Color(0xFF046fa3),
              size: 40,
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
                    ctrl?.loadRequest(Uri.parse('https://www.freelancer.com/'));
                  },
                  icon: const Icon(
                    Icons.account_circle,
                    color: Color(0xFF046fa3),
                  ),
                  iconSize: 35,
                ),
                IconButton(
                  onPressed: () {
                    ctrl?.loadRequest(Uri.parse('https://www.freelancer.com/'));
                  },
                  icon: const Icon(
                    Icons.circle_notifications,
                    color: Color(0xFF046fa3),
                  ),
                  iconSize: 35,
                ),
              ],
            ),
            centerTitle: true,
            toolbarHeight: 0,
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 0,
            //هنا صورة اللوقو اعلى التطبيق
            title: Image.asset('images/s.png', width: 100, height: 50),
          ),
          // body: _isLoading || ctrl == null
          body:
              (_isLoading || ctrl == null) ||
                      (connectionStatus == ConnectivityResult.none)
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(color: Color(0xFFf5f5f6)),

                        SizedBox(height: 50),
                        Text(
                          '',
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
                  : WebViewWidget(controller: ctrl!),
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
