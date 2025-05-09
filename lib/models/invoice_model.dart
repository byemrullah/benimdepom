class Invoice {
  final String id;
  final DateTime date;
  final String customerName;
  final List<InvoiceItem> items;
  final double totalAmount;

  Invoice({
    required this.id,
    required this.date,
    required this.customerName,
    required this.items,
    required this.totalAmount,
  });
}

class InvoiceItem {
  final String productName;
  final int quantity;
  final double unitPrice;
  final double total;

  InvoiceItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}