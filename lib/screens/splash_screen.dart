import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hadi_apps/screens/web_view_screen.dart';

import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 1),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNavScreen()),
      ),
    );

    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // appBar: AppBar(title: const Text(''),backgroundColor: Colors.black,),
      // body: Center(
      //   child: Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      // children: const [
      //   Image(
      //     image: AssetImage('images/s.jpg'),
      //     // width: 1450,
      //     // height: 1450,
      //   ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            // Image(image: NetworkImage('')),
            Image(image: AssetImage('images/start.png')),
            Text('', style: TextStyle(fontSize: 15)),
            // Text(
            //   ':) مــتــجــركـ تسوق ممتع ',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //     fontSize: 16,
            //     color: Color.fromARGB(255, 180, 112, 35),
            //   ),
            // ),
            // Text(
            //  '',
            //   style: TextStyle(fontSize: 15),
            // )
            // Image.asset(
            //   'images/3.png',
            //   width: 200,
            //   height: 200,
            // ),
            // Image.network('src'),
          ],
        ),
      ),
    );
  }
}
