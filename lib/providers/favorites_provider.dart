// ignore: implementation_imports
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  static const _storageKey = 'user_favorites';

  FavoritesNotifier() : super({}) {
    _loadFromDisk();
  }

  /// Reads saved favourite IDs from shared_preferences on startup.
  Future<void> _loadFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_storageKey);
    if (stored != null) {
      state = stored.toSet();
    }
  }

  /// Persists current state to disk.
  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, state.toList());
  }

  /// Toggles a product as favourite / not favourite.
  void toggle(String productId) {
    final updated = {...state};
    if (updated.contains(productId)) {
      updated.remove(productId);
    } else {
      updated.add(productId);
    }
    state = updated;
    _saveToDisk();
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});
