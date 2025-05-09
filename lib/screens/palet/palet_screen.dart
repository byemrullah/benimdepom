import 'package:flutter/material.dart';

class PaletScreen extends StatefulWidget {
  @override
  _PaletScreenState createState() => _PaletScreenState();
}

class _PaletScreenState extends State<PaletScreen> {
  List<String> _workers = ['Çalışan 1', 'Çalışan 2', 'Çalışan 3']; // Örnek çalışan listesi
  String? _selectedWorker;
  TextEditingController _palletCountController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  List<PalletRecord> _palletRecords = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Palet Takibi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Yeni Palet Girişi', style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Çalışan Seç'),
              value: _selectedWorker,
              items: _workers.map((String worker) {
                return DropdownMenuItem<String>(
                  value: worker,
                  child: Text(worker),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedWorker = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen bir çalışan seçin';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _palletCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Palet Sayısı'),
              validator: (value) {
                if (value == null || value.isEmpty || int.tryParse(value) == null) {
                  return 'Lütfen geçerli bir palet sayısı girin';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: <Widget>[
                Text('Tarih Seç: ${_selectedDate == null ? 'Seçilmedi' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'}'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().subtract(Duration(days: 365))),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_selectedWorker != null && _palletCountController.text.isNotEmpty && _selectedDate != null) {
                  final int? palletCount = int.tryParse(_palletCountController.text);
                  if (palletCount != null && palletCount > 0) {
                    setState(() {
                      _palletRecords.add(PalletRecord(
                        worker: _selectedWorker!,
                        count: palletCount,
                        date: _selectedDate!,
                      ));
                      // Formu temizle
                      _selectedWorker = null;
                      _palletCountController.clear();
                      _selectedDate = DateTime.now();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Palet kaydı başarıyla eklendi.')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen geçerli bir palet sayısı girin.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
                  );
                }
              },
              child: Text('Kaydet'),
            ),
            SizedBox(height: 32),
            Text('Kayıtlı Paletler', style: Theme.of(context).textTheme.headline6),
            _palletRecords.isEmpty
                ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Henüz kayıt bulunmamaktadır.'),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _palletRecords.length,
              itemBuilder: (context, index) {
                final record = _palletRecords[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Çalışan: ${record.worker}', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Palet Sayısı: ${record.count}'),
                        Text('Tarih: ${record.date.day}/${record.date.month}/${record.date.year}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PalletRecord {
  final String worker;
  final int count;
  final DateTime date;

  PalletRecord({required this.worker, required this.count, required this.date});
}