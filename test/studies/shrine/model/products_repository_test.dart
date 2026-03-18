import 'package:flutter_test/flutter_test.dart';
import 'package:hackston_lms/studies/shrine/model/product.dart';
import 'package:hackston_lms/studies/shrine/model/products_repository.dart';

void main() {
  group('ProductsRepository', () {
    test('loadProducts returns all products when category is categoryAll', () {
      final products = ProductsRepository.loadProducts(categoryAll);
      expect(products.length, 38);
    });

    test('loadProducts filters by categoryAccessories', () {
      final products = ProductsRepository.loadProducts(categoryAccessories);
      expect(products.every((p) => p.category == categoryAccessories), isTrue);
      expect(products.length, 9);
    });

    test('loadProducts filters by categoryClothing', () {
      final products = ProductsRepository.loadProducts(categoryClothing);
      expect(products.every((p) => p.category == categoryClothing), isTrue);
      expect(products.length, 19);
    });

    test('loadProducts filters by categoryHome', () {
      final products = ProductsRepository.loadProducts(categoryHome);
      expect(products.every((p) => p.category == categoryHome), isTrue);
      expect(products.length, 10);
    });

    test('product properties are correct', () {
      final products = ProductsRepository.loadProducts(categoryAll);
      final firstProduct = products.firstWhere((p) => p.id == 0);
      expect(firstProduct.category, categoryAccessories);
      expect(firstProduct.price, 120);
      expect(firstProduct.isFeatured, isTrue);
    });
  });
}
