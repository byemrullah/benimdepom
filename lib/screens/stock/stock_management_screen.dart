import 'package:flutter/material.dart';

class StockManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stok Yönetimi')),
      body: Center(
        child: Text('Ürün ekleme, stok hareketleri ve uyarılar burada yönetilecek.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni ürün ekleme ekranına yönlendirme
        },
        child: Icon(Icons.add),
      ),
    );
  }
}