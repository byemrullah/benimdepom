import 'package:flutter/material.dart';

class IncomeExpenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gelir ve Giderler')),
      body: Center(
        child: Text('Gelir ve gider kayıtları burada listelenecek ve yeni kayıt eklenebilecek.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni gelir/gider ekleme ekranına yönlendirme
        },
        child: Icon(Icons.add),
      ),
    );
  }
}