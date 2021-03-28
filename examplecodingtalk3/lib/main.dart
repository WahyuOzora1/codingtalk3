import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';

void main() async {
  // Untuk menginisialisasikan project kita ke firebase
  // supaya bisa dikenali oleh spesifik platform/native perlu kita initialize terlebih dahulu.
  WidgetsFlutterBinding.ensureInitialized(); //ada perintah sebelum runApp
  await Firebase
      .initializeApp(); //untuk menambahkan data ke firestore, karena type future kasih async await artinya syncronus dinamis
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
