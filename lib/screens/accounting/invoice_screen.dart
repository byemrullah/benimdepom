import 'package:flutter/material.dart';

class InvoiceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Faturalar')),
      body: Center(
        child: Text('Fatura oluşturma ve listeleme işlemleri burada yapılacak.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni fatura oluşturma ekranına yönlendirme
        },
        child: Icon(Icons.add),
      ),
    );
  }
}