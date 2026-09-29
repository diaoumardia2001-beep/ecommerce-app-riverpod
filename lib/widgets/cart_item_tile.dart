import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';
import '../providers/cart_provider.dart';

/// A single row in the cart list showing product image, name,
/// unit price, quantity controls, subtotal, and a delete button.
class CartItemTile extends ConsumerWidget {
  final CartItem item;
  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final notifier = ref.read(cartProvider.notifier);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ── Product thumbnail ─────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                item.product.imageUrl,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) =>
                    progress == null
                        ? child
                        : const SizedBox(
                            width: 72,
                            height: 72,
                            child: Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2),
                            ),
                          ),
                errorBuilder: (_, __, ___) => Container(
                  width: 72,
                  height: 72,
                  color: colorScheme.surfaceContainerHighest,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // ── Info column ───────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.product.price.toStringAsFixed(2)} \u20ac',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Quantity controls
                  Row(
                    children: [
                      _QuantityButton(
                        icon: Icons.remove,
                        onPressed: () =>
                            notifier.decrement(item.product.id),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '${item.quantity}',
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _QuantityButton(
                        icon: Icons.add,
                        onPressed: () =>
                            notifier.increment(item.product.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Subtotal + delete ─────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.subtotal.toStringAsFixed(2)} \u20ac',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                IconButton(
                  tooltip: 'Supprimer',
                  icon: Icon(Icons.delete_outline,
                      color: colorScheme.error),
                  onPressed: () =>
                      notifier.remove(item.product.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Small rounded icon button used for +/- quantity.
class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _QuantityButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onPressed,
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}
