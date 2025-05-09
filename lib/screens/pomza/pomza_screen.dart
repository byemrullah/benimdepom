import 'package:flutter/material.dart';

class PomzaScreen extends StatefulWidget {
  @override
  _PomzaScreenState createState() => _PomzaScreenState();
}

class _PomzaScreenState extends State<PomzaScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _vehicleController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  double _totalQuantity = 0.0; // Toplam pomza miktarı
  double _paidAmount = 0.0; // Ödenen toplam tutar
  TextEditingController _paymentController = TextEditingController();
  List<PomzaEntry> _pomzaEntries = []; // Pomza girişlerinin listesi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Pomza Yönetimi')),
    body: SingleChildScrollView(
    padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Text('Yeni Pomza Girişi', style: Theme.of(context).textTheme.headline6),
    Form(
    key: _formKey,
    child: Column(
    children: <Widget>[
    TextFormField(
    controller: _vehicleController,
    decoration: InputDecoration(labelText: 'Getiren Araç'),
    ),
    TextFormField(
    controller: _quantityController,
    decoration: InputDecoration(labelText: 'Miktar'),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    validator: (value) {
    if (value == null || value.isEmpty || double.tryParse(value) == null) {
    return 'Lütfen geçerli bir miktar girin';
    }
    return null;
    },
    ),
    Row(
    children: <Widget>[
    Text('Tarih: <span class="math-inline">\{\_selectedDate\!\.day\}/</span>{_selectedDate!.month}/${_selectedDate!.year}'),
    IconButton(
    icon: Icon(Icons.calendar_today),
    onPressed: () async {
    final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: _selectedDate!,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
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
    SizedBox(height: 10),
    ElevatedButton(
    onPressed: () {
    if (_formKey.currentState!.validate()) {
    final double quantity = double.parse(_quantityController.text);
    setState(() {
    _totalQuantity += quantity;
    _pomzaEntries.add(PomzaEntry(
    vehicle: _vehicleController.text,
    quantity: quantity,
    date: _selectedDate!,
    paid: 0.0, // İlk girişte ödeme yok
    ));
    _vehicleController.clear();
    _quantityController.clear();
    });
    print('Pomza Girişi Kaydedildi: Araç - ${_vehicleController.text}, Miktar - $quantity, Tarih - $_selectedDate');
    }
    },
    child: Text('Giriş Kaydet'),
    ),
    ],
    ),
    ),
    SizedBox(height: 20),
    Text('Toplam Pomza Miktarı: ${_totalQuantity.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headline6),
    Text('Ödenen Toplam Tutar: ${_paidAmount.toStringAsFixed(2)}', style: Theme.of(context).textTheme.subtitle1),
    Text('Kalan Miktar: ${(_totalQuantity - _paidAmount).toStringAsFixed(2)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    SizedBox(height: 20),
    Text('Hesaplaşma', style: Theme.of(context).textTheme.headline6),
    TextFormField(
    controller: _paymentController,
    decoration: InputDecoration(labelText: 'Ödenen Tutar (₺)'),
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
    ElevatedButton(
    onPressed: () {
    final double? payment = double.tryParse(_paymentController.text);
    if (payment != null && payment > 0) {
    setState(() {
    _paidAmount += payment;
    _paymentController.clear();
    // İlgili pomza girişine ödeme bilgisini ekleme mantığı eklenebilir
    });
    print('Ödeme Kaydedildi: $payment ₺');
    } else {
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Lütfen geçerli bir ödeme tutarı girin.')),
    );
    }
    },
    child: Text('Ödeme Kaydet'),
    ),
    ElevatedButton(
    onPressed: () {
    setState(() {
    _totalQuantity = 0.0;
    _paidAmount = 0.0;
    _pomzaEntries.clear();
    Scaffold