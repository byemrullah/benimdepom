class Product {
  final String id;
  final String name;
  final String description;
  final double unitPrice;
  int stockQuantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.unitPrice,
    required this.stockQuantity,
  });
}