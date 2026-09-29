// ignore: implementation_imports
import 'package:flutter_riverpod/legacy.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  /// Adds a product to the cart, or increments its quantity if already present.
  void add(Product product) {
    final idx = state.indexWhere((ci) => ci.product.id == product.id);
    if (idx >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx) state[i].copyWith(quantity: state[i].quantity + 1) else state[i],
      ];
    } else {
      state = [...state, CartItem(product: product)];
    }
  }

  /// Removes a product entirely from the cart.
  void remove(String productId) {
    state = state.where((ci) => ci.product.id != productId).toList();
  }

  /// Increases the quantity of the given product by 1.
  void increment(String productId) {
    state = [
      for (final ci in state)
        if (ci.product.id == productId) ci.copyWith(quantity: ci.quantity + 1) else ci,
    ];
  }

  /// Decreases the quantity by 1. Removes the item if it reaches 1.
  void decrement(String productId) {
    final idx = state.indexWhere((ci) => ci.product.id == productId);
    if (idx < 0) return;

    if (state[idx].quantity > 1) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == idx) state[i].copyWith(quantity: state[i].quantity - 1) else state[i],
      ];
    } else {
      remove(productId);
    }
  }

  /// Empties the cart.
  void clear() => state = [];

  /// Whether a product is in the cart.
  bool contains(String productId) =>
      state.any((ci) => ci.product.id == productId);

  /// Total item count (sum of all quantities).
  int get totalItemCount =>
      state.fold<int>(0, (sum, ci) => sum + ci.quantity);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
