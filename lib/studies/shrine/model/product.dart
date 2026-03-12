// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class Category {
  const Category({
    required this.name,
  });

  final String Function(BuildContext) name;
}

Category categoryAll = Category(
  name: (context) => "All",
);

Category categoryAccessories = Category(
  name: (context) => "Accessories",
);

Category categoryClothing = Category(
  name: (context) => "Clothing",
);

Category categoryHome = Category(
  name: (context) => "Home",
);

List<Category> categories = [
  categoryAll,
  categoryAccessories,
  categoryClothing,
  categoryHome,
];

class Product {
  const Product({
    required this.category,
    required this.id,
    required this.isFeatured,
    required this.name,
    required this.price,
    this.assetAspectRatio = 1,
  });

  final Category category;
  final int id;
  final bool isFeatured;
  final double assetAspectRatio;
  final String Function(BuildContext) name;
  final int price;

  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';
}
