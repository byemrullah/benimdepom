import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // Doğru dosya yolunu buraya yazın

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // key parametresini ekledik

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muhasebe Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(), // Doğru sınıf adını buraya yazın
    );
  }
}
