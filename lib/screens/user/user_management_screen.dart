import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kullanıcı Yönetimi')),
      body: Center(
        child: Text('Yeni kullanıcı ekleme ve yetki düzenleme işlemleri burada yapılacak.'),
      ),
    );
  }
}