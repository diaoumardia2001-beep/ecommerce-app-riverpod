import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import 'products_provider.dart';
import 'product_filter_provider.dart';
import 'cart_provider.dart';

// ─────────────────────────────────────────────────────────
//  filteredProductsProvider
//  Combines productsProvider + productFilterProvider.
//  Returns an AsyncValue<List<Product>> so consumers can
//  use .when(data:, loading:, error:) uniformly.
// ─────────────────────────────────────────────────────────
final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final asyncProducts = ref.watch(productsProvider);
  final filter = ref.watch(productFilterProvider);

  return asyncProducts.whenData((products) {
    // 1. Filter by category
    var result = filter.selectedCategory == null
        ? products.toList()
        : products
            .where((p) => p.category == filter.selectedCategory)
            .toList();

    // 2. Sort
    switch (filter.sortOption) {
      case SortOption.nameAsc:
        result.sort((a, b) => a.name.compareTo(b.name));
      case SortOption.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
    }

    return result;
  });
});

// ─────────────────────────────────────────────────────────
//  cartTotalProvider — grand total of the cart
// ─────────────────────────────────────────────────────────
final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<double>(0, (sum, ci) => sum + ci.subtotal);
});

// ─────────────────────────────────────────────────────────
//  cartItemCountProvider — total quantity count for badge
// ─────────────────────────────────────────────────────────
final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<int>(0, (sum, ci) => sum + ci.quantity);
});
