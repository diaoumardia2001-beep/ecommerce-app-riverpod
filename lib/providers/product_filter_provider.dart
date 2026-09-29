// ignore: implementation_imports
import 'package:flutter_riverpod/legacy.dart';

// ─────────────────────────────────────────────────────────
//  Sort options
// ─────────────────────────────────────────────────────────
enum SortOption {
  nameAsc,
  priceAsc,
  priceDesc,
}

// ─────────────────────────────────────────────────────────
//  Filter state (category + sort)
// ─────────────────────────────────────────────────────────
class FilterState {
  /// null means "all categories"
  final String? selectedCategory;
  final SortOption sortOption;

  const FilterState({
    this.selectedCategory,
    this.sortOption = SortOption.nameAsc,
  });

  FilterState copyWith({
    String? Function()? selectedCategory,
    SortOption? sortOption,
  }) {
    return FilterState(
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}

// ─────────────────────────────────────────────────────────
//  Notifier
// ─────────────────────────────────────────────────────────
class ProductFilterNotifier extends StateNotifier<FilterState> {
  ProductFilterNotifier() : super(const FilterState());

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: () => category);
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }
}

final productFilterProvider =
    StateNotifierProvider<ProductFilterNotifier, FilterState>((ref) {
  return ProductFilterNotifier();
});
