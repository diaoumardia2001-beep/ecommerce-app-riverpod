import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/product_repository.dart';
import '../models/product.dart';

/// Exposes the repository as a singleton.
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepository();
});

/// Asynchronously loads the product catalogue.
/// Consumers use AsyncValue.when() to handle loading / error / data.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.fetchProducts();
});
