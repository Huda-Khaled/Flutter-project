import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_apps/my_class/my_navgation.dart';
import 'package:hadi_apps/notificationservice/local_notification_service.dart';
import 'package:hadi_apps/providers/webview_prov.dart';
import 'package:hadi_apps/screens/web_view_screen.dart';
import 'package:hadi_apps/screens/web_view_screencopy.dart';
import 'package:hadi_apps/screens/web_view_screencopyy.dart';
import 'package:hadi_apps/screens/web_view_screencopyyy.dart';
import 'package:hadi_apps/screens/web_view_screencopyyyy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

late ConnectivityResult connectionStatus = ConnectivityResult.none;
final Connectivity _connectivity = Connectivity();
late StreamSubscription<ConnectivityResult> _connectivitySubscription;

class MainNavScreen extends StatefulWidget {
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  bool alertShow = false;
  int valuee = 0;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("message.data22 ${message.data['_id']}");
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging.onMessage.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("message.data11 ${message.data}");
        LocalNotificationService().createanddisplaynotification(message);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance.getInitialMessage");
      if (message != null) {
        print("New Notification");
      }
    });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
      checkConnectivityFunction(result);
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status' + e.toString());
      return;
    }

    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      connectionStatus = result;
    });
    checkConnectivityFunction(result);
  }

  Future<void> _showAlertDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('تنبيه'),
            content: Text('تم فقد اتصالك بالانترنت'),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  await initConnectivity();
                  if (connectionStatus != ConnectivityResult.none) {
                    switch (_count) {
                      case 0:
                        context
                            .read<WebviewProv>()
                            .webViewControllerCopyyy!
                            .reload();
                        break;
                      case 1:
                        context
                            .read<WebviewProv>()
                            .webViewControllerCopyy!
                            .reload();
                        break;
                      case 2:
                        context
                            .read<WebviewProv>()
                            .webViewControllerCopy!
                            .reload();
                        break;
                      case 3:
                        context.read<WebviewProv>().webViewController!.reload();
                        break;
                      default:
                    }
                    alertShow = false;
                    setState(() {});
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyle(fontSize: 20, color: Color(0xFF3C79EC)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkConnectivityFunction(ConnectivityResult result) async {
    if (result == ConnectivityResult.none) {
      if (!alertShow) {
        alertShow = true;
        setState(() {});
        _showAlertDialog(context);
      }
    }
  }

  void onChangeHome() {
    _count = 2;
    setState(() {});
  }

  void onChangePro() {
    _count = 2;
    setState(() {});
  }

  void onChangePro2() {
    _count = 2;
    setState(() {});
  }

  void onChangePro4() {
    _count = 2;
    setState(() {});
  }

  void onChangePro5() {
    _count = 2;
    setState(() {});
  }

  int _count = 3;
  late List<NavBar> listNav = <NavBar>[
    NavBar('Athkar', WebViewScreencopyyy(onChangeNavigation: onChangePro4)),
    NavBar('Pay', WebViewScreencopyy(onChangeNavigation: onChangePro2)),
    NavBar('Profile', WebViewScreencopy(onChangeNavigation: onChangePro)),
    NavBar('Web', WebViewScreen(onChangeNavigation: onChangeHome)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listNav[_count].widget,
      bottomNavigationBar: SizedBox(
        height: 0, // ارتفاع الشريط السفلي
        child: BottomAppBar(
          color: Color(0xFFFFFFFF), // لون الشريط السفلي
        ),
      ),
    );
  }
}
