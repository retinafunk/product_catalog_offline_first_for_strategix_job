///   domain entity 4 product — no Flutter, nneed no dependencies.
class Product {
  const Product({
    required this.id,
    required this.productName,
    required this.productBrand,
    required this.description,
    required this.category,
    required this.priceWithTaxes,
    required this.priceWithoutTaxes,
    required this.thumbnailImage,
    this.productImages = const [],
    this.tags = const [],
    required this.priceKgOrLitre4Compare,
  });

  final int id;
  final String productName;
  final String productBrand;
  final String category;
  final String description;

  final String thumbnailImage;
  final double priceWithTaxes;
  final double priceWithoutTaxes;
  final double priceKgOrLitre4Compare;

  final List<String> productImages;
  final List<String> tags;
}
