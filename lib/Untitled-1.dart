import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BirthdayApp());
}

class BirthdayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Birthday App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BirthdayScreen(),
    );
  }
}

class BirthdayScreen extends StatefulWidget {
  @override
  _BirthdayScreenState createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  String birthdate = '2000-01-01'; // Replace with your birthdate
  bool isBase64 = false;

  void _convertDate() {
    setState(() {
      if (isBase64) {
        try {
          birthdate = utf8.decode(base64.decode(birthdate));
        } catch (e) {
          print("Error decoding base64: $e");
        }
        isBase64 = false;
      } else {
        try {
          birthdate = base64.encode(utf8.encode(birthdate));
        } catch (e) {
          print("Error encoding base64: $e");
        }
        isBase64 = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Birthday App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/birthday_cake.gif',
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              'Birthdate: $birthdate',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertDate,
              child: Text(isBase64 ? 'Decode' : 'Encode'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Play birthday music
          // Example: MethodChannel('com.example.birthday_app/music').invokeMethod('playMusic');
          // You need to handle this method in the platform-specific code (Android/iOS)
        },
        child: Icon(Icons.music_note),
      ),
    );
  }
}
