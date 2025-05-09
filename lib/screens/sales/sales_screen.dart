import 'package:flutter/material.dart';
import 'package:muhasebe_app/models/customer_model.dart'; // Customer modelini import edin
import 'package:muhasebe_app/models/product_model.dart'; // Product modelini import edin
import 'package:muhasebe_app/models/sale_model.dart'; // Sale modelini import edin
import 'package:muhasebe_app/services/database_service.dart'; // Veritabanı işlemleri için (örneğin)
import 'package:math_expressions/math_expressions.dart'; // Hesap makinesi için

class SalesScreen extends StatefulWidget {
  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  // Form anahtarı ve kontrolcüleri tanımlanacak
  final _formKey = GlobalKey<FormState>();
  TextEditingController _sellerController = TextEditingController();
  DateTime? _selectedDate;
  String? _paymentType; // 'Peşin' veya 'Vadeli'
  String? _paymentMethod; // 'Banka' veya 'Elden'
  TextEditingController _shippingInfoController = TextEditingController();
  TextEditingController _shippingCostController = TextEditingController();
  // Müşteri ve ürün seçimi için değişkenler
  Customer? _selectedCustomer;
  Product? _selectedProduct;
  double _productPrice = 0.0;
  double _quantity = 0;
  // Veritabanından alınacak müşteri ve ürün listeleri (örnek verilerle başlatıldı)
  List<Customer> _customers = [];
  List<Product> _products = [];
  //Servis
  final DatabaseService _dbService = DatabaseService();
  String _calculatorInput = '';
  String _calculatorResult = '';

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Verileri yükle
  }

  // Verileri yükleme fonksiyonu (initState içinde çağrılır)
  Future<void> _loadInitialData() async {
    try {
      // Veritabanından müşterileri ve ürünleri al
      _customers = await _dbService.getCustomers(); //Örnek Fonksiyon
      _products = await _dbService.getProducts();  //Örnek Fonksiyon

      setState(() {
        // Veriler yüklendikten sonra ekranı güncelle
      });
    } catch (e) {
      // Hata durumunda kullanıcıya mesaj göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veri yüklenirken bir hata oluştu: $e')),
      );
    }
  }

  // Hesap makinesi fonksiyonları
  void _onCalculatorButtonPress(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _calculatorInput = '';
        _calculatorResult = '';
      } else if (buttonText == '=') {
        try {
          final expression = Parser().parse(_calculatorInput);
          final result =
          expression.evaluate(EvaluationType.REAL, ContextModel());
          _calculatorResult = result.toString();
        } catch (e) {
          _calculatorResult = 'Hata';
        }
        _calculatorInput = _calculatorResult;
      } else {
        _calculatorInput += buttonText;
      }
    });
  }

  // Hesap Makinesi Widget'ı
  Widget _buildCalculator() {
    return Column(
      children: [
        Text(
          _calculatorInput,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.right,
        ),
        Text(
          _calculatorResult,
          style: TextStyle(fontSize: 30, color: Colors.grey),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCalculatorButton('7'),
            _buildCalculatorButton('8'),
            _buildCalculatorButton('9'),
            _buildCalculatorButton('/'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCalculatorButton('4'),
            _buildCalculatorButton('5'),
            _buildCalculatorButton('6'),
            _buildCalculatorButton('*'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCalculatorButton('1'),
            _buildCalculatorButton('2'),
            _buildCalculatorButton('3'),
            _buildCalculatorButton('-'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildCalculatorButton('C', flex: 2),
            _buildCalculatorButton('0'),
            _buildCalculatorButton('='),
            _buildCalculatorButton('+'),
          ],
        ),
      ],
    );
  }

  // Hesap Makinesi Buton Widget'ı
  Widget _buildCalculatorButton(String buttonText, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onCalculatorButtonPress(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Satış Yap')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Müşteri Seçim Alanı (DropdownButtonFormField ile)
              DropdownButtonFormField<Customer>(
                value: _selectedCustomer,
                onChanged: (Customer? newValue) {
                  setState(() {
                    _selectedCustomer = newValue;
                  });
                },
                items: _customers.map<DropdownMenuItem<Customer>>((
                    Customer customer,
                    ) {
                  return DropdownMenuItem<Customer>(
                    value: customer,
                    child: Text(customer.name),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Müşteri Seç'),
                validator: (value) =>
                value == null ? 'Lütfen bir müşteri seçin' : null,
              ),
              SizedBox(height: 20),
              // Tarih Seçim Alanı (InkWell ile showDatePicker)
              Row(
                children: <Widget>[
                  Text('Tarih Seçin: '),
                  Text(_selectedDate == null
                      ? 'Seçilmedi'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
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
              SizedBox(height: 20),
              // Ödeme Şekli Seçim Alanı (RadioListTile'lar)
              Text('Ödeme Şekli:'),
              RadioListTile<String>(
                title: const Text('Peşin'),
                value: 'Peşin',
                groupValue: _paymentType,
                onChanged: (String? value) {
                  setState(() {
                    _paymentType = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Vadeli'),
                value: 'Vadeli',
                groupValue: _paymentType,
                onChanged: (String? value) {
                  setState(() {
                    _paymentType = value;
                  });
                },
              ),
              SizedBox(height: 20),
              // Ürün Seçim Alanı (DropdownButtonFormField ile)
              DropdownButtonFormField<Product>(
                value: _selectedProduct,
                onChanged: (Product? newValue) {
                  setState(() {
                    _selectedProduct = newValue;
                    _productPrice = newValue?.price ??
                        0.0; // Ürün fiyatını otomatik al
                    _calculatorInput =
                        _productPrice.toString(); //fiyatı hesap makinesine yaz
                    _calculatorResult = '';
                  });
                },
                items: _products.map<DropdownMenuItem<Product>>((
                    Product product,
                    ) {
                  return DropdownMenuItem<Product>(
                    value: product,
                    child: Text(product.name),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Ürün Seç'),
                validator: (value) =>
                value == null ? 'Lütfen bir ürün seçin' : null,
              ),
              SizedBox(height: 20),
              // Ürün Fiyatı (Manuel Giriş veya Hesap Makinesi ile hesaplama)
              TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Ürün Fiyatı'),
                value: _calculatorInput.isNotEmpty
                    ? _calculatorInput
                    : _productPrice.toString(),
                onChanged: (value) {
                  setState(() {
                    _calculatorInput = value;
                    _productPrice = double.tryParse(value) ?? 0.0;
                  });
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Lütfen bir fiyat girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Miktar Girişi
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Miktar'),
                onChanged: (value) {
                  setState(() {
                    _quantity = double.tryParse(value) ?? 0;
                  });
                },
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Lütfen miktar girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Ödeme Yöntemi Seçim Alanı (DropdownButtonFormField)
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Ödeme Yöntemi'),
                value: _paymentMethod,
                items: <String>['Banka', 'Elden'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Lütfen ödeme yöntemi seçin' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _shippingInfoController,
                decoration:
                InputDecoration(labelText: 'Nakliye Bilgisi (Nasıl Yapıldı)'),
              ),
              TextFormField(
                controller: _shippingCostController,
                keyboardType:
                TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: 'Nakliye Ücreti (₺)'),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      double.tryParse(value) == null) {
                    return 'Lütfen nakliye ücreti girin';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              // Hesap Makinesi
              _buildCalculator(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _completeSale();
                  }
                },
                child: Text('Satışı Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _completeSale() async {
    // 1. Satış Bilgilerini Oluştur
    final sale = Sale(
      customer: _selectedCustomer!,
      product: _selectedProduct!,
      quantity: _quantity,
      price: _productPrice,
      paymentMethod: _paymentMethod!, // Seçilen ödeme yöntemi
      saleDate: _selectedDate ?? DateTime.now(), // Seçilen tarih veya şimdi
      shippingInfo: _shippingInfoController.text,
      shippingCost: double.tryParse(_shippingCostController.text) ?? 0.0,
    );

    // 2. Veritabanına Kaydet
    try {
      await _dbService.saveSale(sale);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Satış kaydedilirken bir hata oluştu: $e')),
      );
      return; // İşlemi durdur
    }

    // 3. Stoktan Düş
    if (_selectedProduct!.stock >= _quantity) {
      setState(() {
        _selectedProduct!.stock -= _quantity; // Stok güncelle
      });
      try {
        await _dbService.updateProductStock(_selectedProduct!); //Ürün stoğunu günceller
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Stok güncellenirken bir hata oluştu: $e')),
        );
        return;
      }
      print('Stok güncellendi. Yeni stok: ${_selectedProduct!.stock}');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Yetersiz stok! Satış yapılamaz.')),
      );
      return; // Satışı durdur
    }

    // 4. Gelir Kaydı Oluştur ve Müşteri Borç/Alacak Durumunu Güncelle
    try {
      if (_paymentType == 'Peşin') {
        // Müşteri ile mahsuplaşma
        _selectedCustomer!.balance -= (_quantity * _productPrice);
        await _dbService.updateCustomerBalance(_selectedCustomer!);
        print(
            'Peşin Satış Yapıldı. Müşteri bakiyesi: ${_selectedCustomer!.balance}');
      } else {
        // Vadeli satışta müşteri borcunu artır
        _selectedCustomer!.balance += (_quantity * _productPrice);
        await _dbService.updateCustomerBalance(_selectedCustomer!); // müşteri balansı güncellenir
        print(
            'Vadeli Satış Yapıldı. Müşteri bakiyesi: ${_selectedCustomer!.balance}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('Müşteri bakiye/alacak güncellenirken hata oluştu: $e')),
      );
      return;
    }

    // 5. Kullanıcıya Başarı Mesajı Göster
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Satış başarıyla tamamlandı.')),
    );

    // 6. Ekranı Temizle
    setState(() {
      _selectedCustomer = null;
      _selectedProduct = null;
      _productPrice = 0.0;
      _quantity = 0;
      _paymentType = null;
      _paymentMethod = null;
      _calculatorInput = '';
      _calculatorResult = '';
      _shippingInfoController.clear();
      _shippingCostController.clear();
      _selectedDate=null;
    });
    _formKey.currentState?.reset();
  }
}

