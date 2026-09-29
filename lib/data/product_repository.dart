import '../models/product.dart';

class ProductRepository {
  /// Simulates an asynchronous network fetch with a realistic delay.
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _mockProducts;
  }
}

const _mockProducts = <Product>[
  Product(
    id: 'sneakers-air',
    name: 'Sneakers Air Max',
    description:
        'Baskets légères et confortables avec semelle amortissante. '
        'Idéales pour le sport et le quotidien.',
    category: 'Vêtements',
    price: 129.99,
    imageUrl: 'https://picsum.photos/seed/sneakers/400/400',
  ),
  Product(
    id: 'tshirt-premium',
    name: 'T-Shirt Premium',
    description:
        'T-shirt en coton bio doux et respirant. '
        'Coupe ajustée avec finitions soignées.',
    category: 'Vêtements',
    price: 34.99,
    imageUrl: 'https://picsum.photos/seed/tshirt/400/400',
  ),
  Product(
    id: 'jacket-winter',
    name: 'Veste d\'Hiver',
    description:
        'Doudoune légère et chaude, résistante à l\'eau. '
        'Parfaite pour les journées froides.',
    category: 'Vêtements',
    price: 199.99,
    imageUrl: 'https://picsum.photos/seed/jacket/400/400',
  ),
  Product(
    id: 'headphones-pro',
    name: 'Casque Audio Pro',
    description:
        'Casque sans fil avec réduction de bruit active et 30 h d\'autonomie. '
        'Son Hi-Res certifié.',
    category: 'Électronique',
    price: 249.99,
    imageUrl: 'https://picsum.photos/seed/headphones/400/400',
  ),
  Product(
    id: 'smartwatch-x',
    name: 'Montre Connectée X',
    description:
        'Suivi d\'activité, GPS intégré, écran AMOLED. '
        'Étanche jusqu\'à 50 m.',
    category: 'Électronique',
    price: 299.99,
    imageUrl: 'https://picsum.photos/seed/watch/400/400',
  ),
  Product(
    id: 'speaker-boom',
    name: 'Enceinte Bluetooth',
    description:
        'Enceinte portable avec son 360°, basses profondes et 12 h de batterie. '
        'Résistante aux éclaboussures IPX7.',
    category: 'Électronique',
    price: 89.99,
    imageUrl: 'https://picsum.photos/seed/speaker/400/400',
  ),
  Product(
    id: 'lamp-design',
    name: 'Lampe Design LED',
    description:
        'Lampe d\'ambiance avec variateur tactile et lumière chaude. '
        'Design minimaliste en aluminium brossé.',
    category: 'Maison',
    price: 59.99,
    imageUrl: 'https://picsum.photos/seed/lamp/400/400',
  ),
  Product(
    id: 'cushion-velvet',
    name: 'Coussin Velours',
    description:
        'Coussin décoratif en velours doux 45 × 45 cm. '
        'Garnissage moelleux, déhoussable et lavable.',
    category: 'Maison',
    price: 24.99,
    imageUrl: 'https://picsum.photos/seed/cushion/400/400',
  ),
  Product(
    id: 'candle-scented',
    name: 'Bougie Parfumée',
    description:
        'Bougie artisanale en cire de soja, parfum bois de santal et vanille. '
        '40 h de combustion.',
    category: 'Maison',
    price: 19.99,
    imageUrl: 'https://picsum.photos/seed/candle/400/400',
  ),
  Product(
    id: 'backpack-urban',
    name: 'Sac à Dos Urban',
    description:
        'Sac à dos 25 L avec compartiment laptop 15", port USB intégré '
        'et bretelles ergonomiques.',
    category: 'Vêtements',
    price: 79.99,
    imageUrl: 'https://picsum.photos/seed/backpack/400/400',
  ),
];
