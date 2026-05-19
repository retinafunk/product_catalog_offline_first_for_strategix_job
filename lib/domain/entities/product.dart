/// Pure domain entity — no Flutter, no Hive, no Dio dependencies.
class Product {
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.tags,
  });

  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String thumbnail;
  final List<String> images;
  final List<String> tags;
}

