import '../../domain/entities/product.dart';

/// Data-layer model for a product.
///
/// Responsible for JSON serialisation / deserialisation and mapping to the
/// domain [Product] entity. Intentionally has a [toJson] so we can store the
/// product list as a JSON string in Hive without needing code-generated
/// TypeAdapters.
class ProductModel {
  const ProductModel({
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final parsedId = _asInt(json['id']);
    final parsedTitle = _asString(json['title']) ?? _asString(json['name']) ?? '';
    final parsedDescription =
        _asString(json['description']) ?? _asString(json['details']) ?? '';
    final parsedCategory =
        _asString(json['category']) ?? _asString(json['type']) ?? '';
    final parsedPrice = _asDouble(json['price']) ?? _asDouble(json['amount']) ?? 0.0;
    final parsedThumbnail =
        _asString(json['thumbnail']) ?? _asString(json['imageUrl']) ?? '';

    return ProductModel(
      id: parsedId,
      title: parsedTitle,
      description: parsedDescription,
      category: parsedCategory,
      price: parsedPrice,
      thumbnail: parsedThumbnail,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => '$e')
              .toList() ??
          [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => '$e')
              .toList() ??
          [],
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }

  static double? _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return '$value';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'price': price,
        'thumbnail': thumbnail,
        'images': images,
        'tags': tags,
      };

  /// Maps this data model to the pure domain [Product] entity.
  Product toEntity() => Product(
        id: id,
        title: title,
        description: description,
        category: category,
        price: price,
        thumbnail: thumbnail,
        images: images,
        tags: tags,
      );
}

