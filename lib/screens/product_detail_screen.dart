import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(productsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: asyncProducts.when(
        data: (products) {
          final product =
              products.firstWhere((p) => p.id == productId);
          final isFav = ref.watch(favoritesProvider).contains(product.id);
          final isInCart = ref
              .watch(cartProvider)
              .any((ci) => ci.product.id == product.id);

          return CustomScrollView(
            slivers: [
              // ── Collapsing app bar with hero image ──────
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go('/'),
                ),
                actions: [
                  IconButton(
                    tooltip: isFav
                        ? 'Retirer des favoris'
                        : 'Ajouter aux favoris',
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : null,
                    ),
                    onPressed: () => ref
                        .read(favoritesProvider.notifier)
                        .toggle(product.id),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'product-image-${product.id}',
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (_, child, progress) =>
                          progress == null
                              ? child
                              : const Center(
                                  child: CircularProgressIndicator()),
                      errorBuilder: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              size: 64),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ── Product details ─────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Name
                      Text(
                        product.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Price
                      Text(
                        '${product.price.toStringAsFixed(2)} \u20ac',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description
                      Text(
                        'Description',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Add‑to‑cart button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                isInCart ? Colors.green : colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: Icon(
                            isInCart
                                ? Icons.check
                                : Icons.add_shopping_cart,
                          ),
                          label: Text(
                            isInCart
                                ? 'Déjà dans le panier'
                                : 'Ajouter au panier',
                            style: const TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .add(product);
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      '${product.name} ajouté au panier'),
                                  action: SnackBarAction(
                                    label: 'Voir le panier',
                                    onPressed: () => context.go('/cart'),
                                  ),
                                ),
                              );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
      ),
    );
  }
}
