import 'package:flutter/material.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Raporlar')),
      body: Center(
        child: Text('Farklı rapor türlerini görüntüleme seçenekleri burada olacak.'),
      ),
    );
  }
}