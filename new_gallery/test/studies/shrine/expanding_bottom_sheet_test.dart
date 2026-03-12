import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallery/studies/shrine/expanding_bottom_sheet.dart';
import 'package:gallery/studies/shrine/model/app_state_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:gallery/data/gallery_options.dart';

void main() {
  group('ExpandingBottomSheet cart management', () {
    testWidgets('adds products to list', (WidgetTester tester) async {
      final model = AppStateModel();
      model.loadProducts();

      await tester.pumpWidget(
        ModelBinding(
          initialModel: const GalleryOptions(
            themeMode: ThemeMode.system,
            textScaleFactor: 1.0,
            customTextDirection: CustomTextDirection.localeBased,
            locale: null,
            timeDilation: 1.0,
            platform: null,
            isTestMode: true,
          ),
          child: ScopedModel<AppStateModel>(
            model: model,
            child: const MaterialApp(
              home: Scaffold(
                body: ProductThumbnailRow(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(ProductThumbnail), findsNothing);

      // Add a product
      model.addProductToCart(model.getProducts()[0].id);
      await tester.pumpAndSettle();
      expect(find.byType(ProductThumbnail), findsOneWidget);

      // Add another product
      model.addProductToCart(model.getProducts()[1].id);
      await tester.pumpAndSettle();
      expect(find.byType(ProductThumbnail), findsNWidgets(2));
    });

    testWidgets('removes products from list', (WidgetTester tester) async {
      final model = AppStateModel();
      model.loadProducts();

      await tester.pumpWidget(
        ModelBinding(
          initialModel: const GalleryOptions(
            themeMode: ThemeMode.system,
            textScaleFactor: 1.0,
            customTextDirection: CustomTextDirection.localeBased,
            locale: null,
            timeDilation: 1.0,
            platform: null,
            isTestMode: true,
          ),
          child: ScopedModel<AppStateModel>(
            model: model,
            child: const MaterialApp(
              home: Scaffold(
                body: ProductThumbnailRow(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Add two products
      model.addProductToCart(model.getProducts()[0].id);
      model.addProductToCart(model.getProducts()[1].id);
      await tester.pumpAndSettle();
      expect(find.byType(ProductThumbnail), findsNWidgets(2));

      // Remove the first product
      model.removeItemFromCart(model.getProducts()[0].id);
      await tester.pumpAndSettle();

      // Verify we have 1 ProductThumbnail remaining
      expect(find.byType(ProductThumbnail), findsOneWidget);

      // Remove the second product
      model.removeItemFromCart(model.getProducts()[1].id);
      await tester.pumpAndSettle();

      expect(find.byType(ProductThumbnail), findsNothing);
    });

    testWidgets('clears products from list', (WidgetTester tester) async {
      final model = AppStateModel();
      model.loadProducts();

      await tester.pumpWidget(
        ModelBinding(
          initialModel: const GalleryOptions(
            themeMode: ThemeMode.system,
            textScaleFactor: 1.0,
            customTextDirection: CustomTextDirection.localeBased,
            locale: null,
            timeDilation: 1.0,
            platform: null,
            isTestMode: true,
          ),
          child: ScopedModel<AppStateModel>(
            model: model,
            child: const MaterialApp(
              home: Scaffold(
                body: ProductThumbnailRow(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Add two products
      model.addProductToCart(model.getProducts()[0].id);
      model.addProductToCart(model.getProducts()[1].id);
      await tester.pumpAndSettle();
      expect(find.byType(ProductThumbnail), findsNWidgets(2));

      // Clear the cart
      model.clearCart();
      await tester.pumpAndSettle();

      // Verify we have 0 ProductThumbnails
      expect(find.byType(ProductThumbnail), findsNothing);
    });
  });
}
