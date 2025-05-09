import 'package:flutter/material.dart';

class LaborCostScreen extends StatefulWidget {
  @override
  _LaborCostScreenState createState() => _LaborCostScreenState();
}

class _LaborCostScreenState extends State<LaborCostScreen> {
  List<Worker> _workers = []; // Çalışan listesi
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _wageController = TextEditingController();
  TextEditingController _amountPaidController = TextEditingController();
  List<LaborCostRecord> _laborCostRecords = []; // İşçilik gideri kayıtları

  // Yeni çalışan ekleme fonksiyonu
  void _addWorker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Yeni Çalışan Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'İsim Soyisim'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefon No'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _wageController,
                decoration: InputDecoration(labelText: 'Alınan Ücret'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
                _clearNewWorkerFields();
              },
            ),
            ElevatedButton(
              child: Text('Ekle'),
              onPressed: () {
                if (_nameController.text.isNotEmpty && _wageController.text.isNotEmpty) {
                  setState(() {
                    _workers.add(Worker(
                      name: _nameController.text,
                      phone: _phoneController.text,
                      wage: double.tryParse(_wageController.text) ?? 0.0,
                      remainingWage: double.tryParse(_wageController.text) ?? 0.0,
                    ));
                    _clearNewWorkerFields();
                    Navigator.of(context).pop();
                  });
                } else {
                  // Hata mesajı
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Yeni çalışan ekleme alanlarını temizleme
  void _clearNewWorkerFields() {
    _nameController.clear();
    _phoneController.clear();
    _wageController.clear();
  }

  // İşçilik kaydı ekleme fonksiyonu
  void _recordPayment(Worker worker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ödeme Kaydı'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _amountPaidController,
                decoration: InputDecoration(labelText: 'Ödenen Miktar'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
                _amountPaidController.clear();
              },
            ),
            ElevatedButton(
              child: Text('Öde'),
              onPressed: () {
                final amountPaid = double.tryParse(_amountPaidController.text) ?? 0.0;
                if (amountPaid > 0) {
                  setState(() {
                    worker.remainingWage -= amountPaid;
                    _laborCostRecords.add(LaborCostRecord(
                      worker: worker,
                      date: DateTime.now(),
                      amountPaid: amountPaid,
                    ));
                  });
                  _amountPaidController.clear();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Geçerli bir ödeme tutarı girin!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('İşçilik Giderleri')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _workers.length,
              itemBuilder: (context, index) {
                final worker = _workers[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(worker.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Telefon: ${worker.phone}'),
                        Text('Alınan Ücret: ${worker.wage.toStringAsFixed(2)} ₺'),
                        Text('Kalan Ücret: ${worker.remainingWage.toStringAsFixed(2)} ₺'),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _recordPayment(worker),
                          child: Text('Ödeme Kaydet'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addWorker,
              child: Text('Yeni Çalışan Ekle'),
            ),
          ),
        ],
      ),
    );
  }
}

class Worker {
  final String name;
  final String phone;
  final double wage;
  double remainingWage;

  Worker({required this.name, required this.phone, required this.wage, required this.remainingWage});
}

class LaborCostRecord {
  final Worker worker;
  final DateTime date;
  final double amountPaid;

  LaborCostRecord({required this.worker, required this.date, required this.amountPaid});
}
