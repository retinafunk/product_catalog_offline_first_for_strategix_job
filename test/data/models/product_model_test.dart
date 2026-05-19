import 'package:flutter_test/flutter_test.dart';
import 'package:product_catalog_offline_first_for_strategix_job/data/models/product_model.dart';

void main() {
  group('ProductModel.fromJson', () {
    test('parses current API/cache shape', () {
      final model = ProductModel.fromJson({
        'id': 1,
        'title': 'Phone',
        'description': 'Flagship',
        'category': 'electronics',
        'price': 599.99,
        'thumbnail': 'thumb.png',
        'images': ['a.png', 'b.png'],
        'tags': ['new'],
      });

      expect(model.id, 1);
      expect(model.title, 'Phone');
      expect(model.thumbnail, 'thumb.png');
      expect(model.price, 599.99);
      expect(model.images, ['a.png', 'b.png']);
    });

    test('parses legacy cache shape with fallback fields', () {
      final model = ProductModel.fromJson({
        'id': '2',
        'name': 'Laptop',
        'details': 'Workstation',
        'type': 'computers',
        'amount': '1299.50',
        'imageUrl': 'legacy-thumb.png',
        'images': [123, 'img2.png'],
        'tags': [true, 'sale'],
      });

      expect(model.id, 2);
      expect(model.title, 'Laptop');
      expect(model.description, 'Workstation');
      expect(model.category, 'computers');
      expect(model.price, 1299.50);
      expect(model.thumbnail, 'legacy-thumb.png');
      expect(model.images, ['123', 'img2.png']);
      expect(model.tags, ['true', 'sale']);
    });
  });
}

