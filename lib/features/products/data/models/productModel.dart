import '../../domain-logic/entities/product_entity.dart';

/// Data-layer model for a product.
/// Mirrors the domain  entity [Product:_entity]
class ProductModel {
  const ProductModel({
    required this.id,
    required this.productName,
    required this.productBrand,
    required this.description,
    required this.category,
    required this.priceWithTaxes,
    required this.priceWithoutTaxes,
    required this.thumbnailImage,
    required this.priceKgOrLitre4Compare,
    this.productImages = const [],
    required this.tags,
  });

  final int id;
  final String productName;
  final String productBrand;
  final String description;
  final String category;
  final double priceWithTaxes;
  final double priceWithoutTaxes;
  final String thumbnailImage;
  final double priceKgOrLitre4Compare;
  final List<String> productImages;
  final List<String> tags;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      productName:
          json['productName'] as String? ?? json['title'] as String? ?? '',
      productBrand:
          json['productBrand'] as String? ?? json['brand'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      priceWithTaxes:
          (json['priceWithTaxes'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      priceWithoutTaxes:
          (json['priceWithoutTaxes'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      thumbnailImage:
          json['thumbnailImage'] as String? ?? json['thumbnail'] as String? ?? '',
      priceKgOrLitre4Compare:
          (json['priceKgOrLitre4Compare'] as num?)?.toDouble() ??
          (json['priceLorLitre'] as num?)?.toDouble() ??
          0.0,
      productImages:
          (json['productImages'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'productName': productName,
    'productBrand': productBrand,
    'description': description,
    'category': category,
    'priceWithTaxes': priceWithTaxes,
    'priceWithoutTaxes': priceWithoutTaxes,
    'thumbnailImage': thumbnailImage,
    'priceKgOrLitre4Compare': priceKgOrLitre4Compare,
    'productImages': productImages,
    'tags': tags,
  };

  /// Maps this data model to the pure domain [Product] entity.
  Product toEntity() => Product(
    id: id,
    productName: productName,
    productBrand: productBrand,
    description: description,
    category: category,
    priceWithTaxes: priceWithTaxes,
    priceWithoutTaxes: priceWithoutTaxes,
    thumbnailImage: thumbnailImage,
    productImages: productImages,
    tags: tags,
    priceKgOrLitre4Compare: priceKgOrLitre4Compare,
  );
}
