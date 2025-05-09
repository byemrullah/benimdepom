import 'package:flutter/material.dart';
import '../models/worker_model.dart'; // Worker sınıfını kullanmak için

class MoldScreen extends StatefulWidget {
  final List<Worker> workers; // Çalışan listesini dışarıdan alabiliriz

  MoldScreen({Key? key, required this.workers}) : super(key: key);

  @override
  _MoldScreenState createState() => _MoldScreenState();
}

class _MoldScreenState extends State<MoldScreen> {
  TextEditingController _moldCountController = TextEditingController();
  List<Worker> _selectedWorkers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Kalıp Dağıtımı')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _moldCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Kalıp Sayısı'),
            ),
            SizedBox(height: 16),
            Text('Çalışanlar:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: widget.workers.length,
                itemBuilder: (context, index) {
                  final worker = widget.workers[index];
                  return CheckboxListTile(
                    title: Text(worker.name),
                    value: _selectedWorkers.contains(worker),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedWorkers.add(worker);
                        } else {
                          _selectedWorkers.remove(worker);
                        }
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final moldCount = int.tryParse(_moldCountController.text);
                if (moldCount != null && moldCount > 0 && _selectedWorkers.isNotEmpty) {
                  final moldsPerWorker = moldCount / _selectedWorkers.length;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Kalıp Dağıtım Sonucu'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _selectedWorkers.map((worker) {
                            return Text('${worker.name}: ${moldsPerWorker.toStringAsFixed(2)} kalıp');
                          }).toList(),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Tamam'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen geçerli bir kalıp sayısı girin ve en az bir çalışan seçin.')),
                  );
                }
              },
              child: Text('Kalıpları Dağıt'),
            ),
          ],
        ),
      ),
    );
  }
}
