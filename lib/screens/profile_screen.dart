import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff2386c8),
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          CircleAvatar(
            radius: 80,
          ),
          SizedBox(height: 12),
          Text(
            'Name : Adham AlAshi',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          SizedBox(height: 12),
          Text('email: adham@adham.com',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        ],
      ),
    );
  }
}
