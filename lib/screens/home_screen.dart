import 'package:flutter/material.dart';
import 'package:acrbims/screens/sales/sales_screen.dart';
import 'package:acrbims/screens/pomza/pomza_screen.dart';
import 'package:acrbims/screens/palet/palet_screen.dart';
import 'package:acrbims/screens/mold/mold_screen.dart';
import 'package:acrbims/widgets/custom_drawer.dart';
import 'package:acrbims/models/worker_model.dart'; // Worker modelini içe aktardık

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Örnek çalışan listesi
  final List<Worker> _workers = [
    Worker(name: 'Ahmet Yılmaz', phone: '555-123-4567', wage: 0, remainingWage: 0),
    Worker(name: 'Ayşe Kaya', phone: '555-987-6543', wage: 0, remainingWage: 0),
    Worker(name: 'Mehmet Demir', phone: '555-246-8012', wage: 0, remainingWage: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Ekran'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showQuickActionsDialog(context);
              },
            ),
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            const InfoCard(
              title: 'Gelir',
              value: '₺XXXX.XX',
              color: Colors.green,
            ),
            const SizedBox(width: 16),
            const InfoCard(
              title: 'Kasa',
              value: '₺YYYY.YY',
              color: Colors.blue,
            ),
            const SizedBox(width: 16),
            const InfoCard(
              title: 'Gider',
              value: '₺ZZZZ.ZZ',
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hızlı Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Satış Yap'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SalesScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Pomza Ekle'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PomzaScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Palet Ekle'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaletScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('Kalıp Ekle'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MoldScreen(workers: _workers)), // Çalışan listesini gönderiyoruz
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const InfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
