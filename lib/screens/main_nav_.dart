import 'dart:async';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_apps/my_class/my_navgation.dart';
import 'package:hadi_apps/notificationservice/local_notification_service.dart';
import 'package:hadi_apps/providers/webview_prov.dart';

//import 'package:flutter_hadi/screens/athkar_screen.dart';
//import 'package:flutter_hadi/screens/profile_screen.dart';
import 'package:hadi_apps/screens/web_view_screen.dart';

//import 'package:webview_flutter/webview_flutter.dart';
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
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    super.initState();

    // 1. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("message.data22 ${message.data['_id']}");
      }
    });

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen((message) {
      print("FirebaseMessaging.onMessage.listen");
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("message.data11 ${message.data}");
        LocalNotificationService().createanddisplaynotification(message);
      }
    });

    // 3. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print("FirebaseMessaging.instance.getInitialMessage");
      if (message != null) {
        print("New Notification");
        // if (message.data['_id'] != null) {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (context) => DemoScreen(
        //         id: message.data['_id'],
        //       ),
        //     ),
        //   );
        // }
      }
    });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
      checkConnectivityFunction(result);
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status' + e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
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
                        // context.read<WebviewProv>().resetCtrlCopyyyy();
                        context
                            .read<WebviewProv>()
                            .webViewControllerCopyyyy!
                            .reload();

                        break;
                      case 0:
                        // context.read<WebviewProv>().resetCtrlCopyyy();
                        context
                            .read<WebviewProv>()
                            .webViewControllerCopyyy!
                            .reload();

                        break;
                      case 1:
                        // context.read<WebviewProv>().resetCtrlCopyy();
                        context
                            .read<WebviewProv>()
                            .webViewControllerCopyy!
                            .reload();

                        break;
                      case 2:
                        // context.read<WebviewProv>().resetCtrlCopy();

                        context
                            .read<WebviewProv>()
                            .webViewControllerCopy!
                            .reload();

                        break;
                      case 3:
                        // context.read<WebviewProv>().resetCtrl();
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
                  style: TextStyle(fontSize: 20, color: Color(0xFF000000)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkConnectivityFunction(
    final ConnectivityResult result,
  ) async {
    if (result == ConnectivityResult.mobile) {
    } else if (result == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
    } else if (result == ConnectivityResult.ethernet) {
      // I am connected to a ethernet network.
    } else if (result == ConnectivityResult.vpn) {
      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (result == ConnectivityResult.bluetooth) {
      // I am connected to a bluetooth.
    } else if (result == ConnectivityResult.other) {
      if (!alertShow) {
        alertShow = true;
        setState(() {});
        _showAlertDialog(context);
      }
    } else if (result == ConnectivityResult.none) {
      if (!alertShow) {
        alertShow = true;
        setState(() {});
        _showAlertDialog(context);
      }
    }
  }

  //هنا يتم وضع ترتيب الصفحات عند تشغيل التطبيق وتسميتها
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

  int _count = 4;
  late List<NavBar> listNav = <NavBar>[
    // NavBar('Athkar', WebViewScreencopyyyy()),
    // NavBar('Athkar', WebViewScreencopyyyy()),
    NavBar('Athkar', WebViewScreencopyyyy(onChangeNavigation: onChangePro5)),
    NavBar('Athkar', WebViewScreencopyyy(onChangeNavigation: onChangePro4)),
    NavBar('Pay', WebViewScreencopyy(onChangeNavigation: onChangePro2)),
    NavBar('Profile', WebViewScreencopy(onChangeNavigation: onChangePro)),
    NavBar('Web', WebViewScreen(onChangeNavigation: onChangeHome)),
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listNav[_count].widget,
      bottomNavigationBar: Consumer<WebviewProv>(
        builder: (_, prov, __) {
          return BottomNavigationBar(
            currentIndex: _count,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            unselectedFontSize: 12,
            selectedFontSize: 14,
            onTap: (value) {
              valuee = value;
              setState(() {});
              log(_count);
              log(value);
              //هنا اذا تم الضغط علي زر الرئيسية مثلا يحدث او باقي الازرار
              if (value == 4) {
                if (_count == 4) prov.resetCtrl();
              } else if (value == 2) {
                if (_count == 2) prov.resetCtrlCopyy();
              } else if (value == 1) {
                if (_count == 1) prov.resetCtrlCopyyy();
              } else if (value == 3) {
                if (_count == 3) prov.resetCtrlCopy();
              } else if (value == 0) {
                if (_count == 0) prov.resetCtrlCopyyyy();
              }
              setState(() {
                _count = value;
              });
            },
            selectedItemColor: Color.fromARGB(255, 0, 0, 0),
            unselectedItemColor: Color.fromARGB(255, 158, 158, 162),
            backgroundColor: Color(0xFFf5f5f6),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'حسابي',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active_outlined),
                label: 'الاشعارات',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.local_grocery_store_outlined),
                label: 'السلة ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.apps_sharp),
                label: 'التصنيفات',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'الرئيسية',
              ),
              // ايقونة القائمة
              // filter_list_rounded
              // grid_view_rounded
              // list_sharp
            ],
          );
        },
      ),
    );
  }
}
// flutter build apk --split-per-abi

// flutter build apk --split-per-abi
