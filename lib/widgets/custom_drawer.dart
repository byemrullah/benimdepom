import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/user/user_management_screen.dart';
import '../screens/accounting/income_expense_screen.dart';
import '../screens/customer/customer_management_screen.dart';
import '../screens/stock/stock_management_screen.dart';
import '../screens/pomza/pomza_screen.dart';
import '../screens/settings/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profil'),
            onTap: () {
              // Profil ekranına yönlendirme (henüz oluşturulmadıysa)
              Navigator.pop(context); // Çekmeceyi kapat
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_downward),
            title: Text('Gelir'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IncomeExpenseScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.arrow_upward),
            title: Text('Gider'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IncomeExpenseScreen()), // Aynı ekran veya ayrı bir gider ekranı olabilir
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Müşteriler'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory),
            title: Text('Stok'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StockManagementScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.grain),
            title: Text('Pomza'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PomzaScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text('Palet'),
            onTap: () {
              Navigator.pop(context);
              // Palet ekranına yönlendirme (henüz oluşturulmadıysa)
            },
          ),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('İşçilik Giderleri'),
            onTap: () {
              Navigator.pop(context);
              // İşçilik Giderleri ekranına yönlendirme (henüz oluşturulmadıysa)
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Ayarlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Çıkış'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()), // Giriş ekranına geri dön
              );
            },
          ),
        ],
      ),
    );
  }
}