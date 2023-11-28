import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projectakhir_kelompok_resep/halaman_login.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive Flutter

import 'feedback/feedback_model.dart';

void main() async{
  await Hive.initFlutter();
  await Hive.openBox('favoriteBox');
  Hive.registerAdapter(FeedbackModelAdapter());
  await Hive.openBox<FeedbackModel>('feedbackBox');


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resep Makanan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
      home: LoginPage(),
    );
  }
}