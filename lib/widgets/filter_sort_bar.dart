import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/product_filter_provider.dart';

/// Horizontal bar with category filter chips and a sort dropdown.
class FilterSortBar extends ConsumerWidget {
  const FilterSortBar({super.key});

  static const _categories = [
    null, // "Tout"
    'Vêtements',
    'Électronique',
    'Maison',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(productFilterProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Category chips ───────────────────────────────
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = filter.selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat ?? 'Tout'),
                  selected: selected,
                  showCheckmark: false,
                  onSelected: (_) =>
                      ref.read(productFilterProvider.notifier).setCategory(cat),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // ── Sort selector ────────────────────────────────
          Row(
            children: [
              Icon(Icons.sort, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text('Trier par :', style: theme.textTheme.bodyMedium),
              const SizedBox(width: 8),
              DropdownButton<SortOption>(
                value: filter.sortOption,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(12),
                items: const [
                  DropdownMenuItem(
                    value: SortOption.nameAsc,
                    child: Text('Nom A\u2011Z'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.priceAsc,
                    child: Text('Prix croissant'),
                  ),
                  DropdownMenuItem(
                    value: SortOption.priceDesc,
                    child: Text('Prix décroissant'),
                  ),
                ],
                onChanged: (opt) {
                  if (opt != null) {
                    ref
                        .read(productFilterProvider.notifier)
                        .setSortOption(opt);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
