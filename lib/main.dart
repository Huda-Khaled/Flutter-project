
// //=======> الكود دا حضرتك هتفعله تعمل به تست الاول تشوف فيه لو ظهر ذي الصوره الا في الشات يبقي تمام

// import 'package:flutter/material.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// void main() {
// WidgetsFlutterBinding.ensureInitialized();

// // تهيئة OneSignal
// OneSignal.initialize("aca86be8-4e36-4c23-a2e4-627043f7021b"); // دا ال هIDديك ال App ID بتاعك من موقع OneSignal

// // إعدادات الإشعارات
// OneSignal.Notifications.requestPermission(true);

// // طباعة في الكونسول عند التشغيل
// OneSignal.Notifications.addPermissionObserver((state) {
// print("🔔 Notification permission: $state");
// });

// // التحقق من الاشتراك
// OneSignal.User.pushSubscription.addObserver((state) {
// print(" Push Subscription State Changed:");// دا هيطبعلك حالة الاشتراك في الإشعارات
// print(" Is Subscribed: ${state.current.optedIn}");// دا هيطبعلك هل المستخدم مشترك في الإشعارات أم لا
// print(" ID: ${state.current.id}");// دا هيطبعلك ال ID بتاع المستخدم
// print(" Token: ${state.current.token}");// دا هيطبعلك ال Token بتاع المستخدم
// });

// runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
// @override
// Widget build(BuildContext context) {
// return MaterialApp(
// title: 'OneSignal Test',
// home: Scaffold(
// appBar: AppBar(title: Text('OneSignal Demo')),
// body: Center(child: Text('Check the console for logs')),
// ),
// );
// }
// }






import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:hadi_apps/providers/webview_prov.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hadi_apps/screens/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize OneSignal
  OneSignal.initialize("aca86be8-4e36-4c23-a2e4-627043f7021b");

  // Request permission on iOS
  OneSignal.Notifications.requestPermission(true); 

  InterstitialAd? _interstitialAd;
  MobileAds.instance.initialize();
  InterstitialAd.load(
    adUnitId: '',
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
  Timer.periodic(const Duration(seconds: 30), (timer) {
    _interstitialAd?.show();
  });
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WebviewProv>(create: (_) => WebviewProv()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}
