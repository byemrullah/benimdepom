import 'package:flutter/material.dart';
import 'package:muhasebe_app/models/customer_model.dart'; // Customer modelini import edin
import 'package:muhasebe_app/services/database_service.dart'; // Veritabanı işlemleri için (örneğin)

class CustomerManagementScreen extends StatefulWidget {
  @override
  _CustomerManagementScreenState createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  // Veritabanından alınacak müşteri listesi
  List<Customer> _customers = [];
  //Veritabanı
  final DatabaseService _dbService = DatabaseService();

  // Yeni müşteri eklemek için form kontrolcüleri
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomers(); // Müşteri listesini yükle
  }

  // Müşteri listesini yükleme fonksiyonu
  Future<void> _loadCustomers() async {
    try {
      _customers = await _dbService.getCustomers(); // Müşterileri al
      setState(() {}); // Ekranı güncelle
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('Müşteri verileri yüklenirken bir hata oluştu: $e')),
      );
    }
  }

  // Müşteri detaylarını gösterme fonksiyonu
  void _showCustomerDetails(Customer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(customer.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Telefon: ${customer.phone}'),
              Text('Adres: ${customer.address}'),
              Text('Bakiye: ${customer.balance.toStringAsFixed(2)} ₺'), // Bakiyeyi göster
              // Burada satış geçmişi ve ödeme geçmişi gibi detaylar da gösterilebilir
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Kapat'),
            ),
            TextButton(
              onPressed: () {
                // Müşteri düzenleme fonksiyonunu çağır
                _editCustomer(customer);
              },
              child: Text('Düzenle'),
            ),
            TextButton(
              onPressed: () {
                // Müşteri silme fonksiyonunu çağır
                _deleteCustomer(customer);
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  // Müşteri düzenleme fonksiyonu
  void _editCustomer(Customer customer) {
    // Form kontrolcülerini mevcut müşteri bilgileriyle doldur
    _nameController.text = customer.name;
    _phoneController.text = customer.phone;
    _addressController.text = customer.address;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Müşteri Düzenle'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Müşteri Adı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen müşteri adını girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Telefon Numarası'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Adres'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen adres girin';
                    }
                    return null;
                  },
                  // Adres alanına tıklandığında herhangi bir özel işlem yapılmasına gerek yok,
                  // klavye otomatik olarak açılacaktır.
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearFormFields(); //formu temizle
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Güncellenmiş müşteri bilgilerini al
                  final updatedCustomer = Customer(
                    id: customer.id, // ID'yi koru
                    name: _nameController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    balance: customer.balance, // Mevcut bakiyeyi koru
                  );

                  // Veritabanında müşteriyi güncelle
                  try {
                    await _dbService.updateCustomer(updatedCustomer);
                    // Listeyi ve ekranı güncelle
                    await _loadCustomers();
                    Navigator.of(context).pop();
                    _clearFormFields();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Müşteri bilgileri güncellendi.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Müşteri güncellenirken bir hata oluştu: $e')),
                    );
                  }
                }
              },
              child: Text('Kaydet'),
            ),
          ],
        );
      },
    );
  }

  // Müşteri silme fonksiyonu
  void _deleteCustomer(Customer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Müşteriyi Sil'),
          content: Text(
              '${customer.name} adlı müşteriyi silmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Veritabanından müşteriyi sil
                try {
                  await _dbService.deleteCustomer(customer.id);
                  // Listeyi ve ekranı güncelle
                  await _loadCustomers();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Müşteri silindi.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Müşteri silinirken bir hata oluştu: $e')),
                  );
                }
              },
              child: Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  void _clearFormFields() {
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
  }

  // Yeni müşteri ekleme fonksiyonu
  void _addCustomer() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Yeni Müşteri Ekle'),
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Müşteri Adı'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen müşteri adını girin';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Telefon Numarası'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Adres'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen adres girin';
                    }
                    return null;
                  },
                  // Adres alanına tıklandığında herhangi bir özel işlem yapılmasına gerek yok,
                  // klavye otomatik olarak açılacaktır.
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearFormFields();
              },
              child: Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Yeni müşteri oluştur
                  final newCustomer = Customer(
                    id: DateTime.now().toString(), // Geçici ID (veritabanı atayacak)
                    name: _nameController.text,
                    phone: _phoneController.text,
                    address: _addressController.text,
                    balance: 0.0, // Başlangıç bakiyesi 0
                  );
                  // Veritabanına ekle
                  try {
                    await _dbService.saveCustomer(newCustomer);
                    // Listeyi ve ekranı güncelle
                    await _loadCustomers();
                    Navigator.of(context).pop();
                    _clearFormFields();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Müşteri eklendi.')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Müşteri eklenirken bir hata oluştu: $e')),
                    );
                  }
                }
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Müşteri Yönetimi')),
      body: Column(
        children: [
          Expanded(
            child: _customers.isEmpty
                ? const Center(child: Text("Henüz Müşteri Yok"))
                : ListView.builder(
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final customer = _customers[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(customer.name),
                    subtitle: Text(customer.phone),
                    onTap: () =>
                        _showCustomerDetails(customer), // Detayları göster
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addCustomer, // Yeni müşteri ekle
              child: Text('Yeni Müşteri Ekle'),
            ),
          ),
        ],
      ),
    );
  }
}

