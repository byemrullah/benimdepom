
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ayarlar')),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Veri Yedekleme'),
            onTap: () {
              // Yedekleme işlemini başlat
              print('Veri yedekleme başlatıldı.');
              // Burada veri yedekleme mantığı implemente edilecek (database_service.dart)
            },
          ),
          ListTile(
            title: Text('Veri Geri Yükleme'),
            onTap: () {
              // Geri yükleme işlemini başlat
              print('Veri geri yükleme başlatıldı.');
              // Burada veri geri yükleme mantığı implemente edilecek (database_service.dart)
            },
          ),
          // Diğer ayarlar buraya eklenebilir
        ],
      ),
    );
  }
}