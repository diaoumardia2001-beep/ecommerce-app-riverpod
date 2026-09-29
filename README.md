# 🛍️ ShopEase — App E-Commerce Flutter avec Riverpod

Application e-commerce Flutter professionnelle utilisant **exclusivement Riverpod** comme solution de state management, avec une architecture en couches claire, un design Material 3 soigné, et des animations fluides.

---

## 📸 Fonctionnalités

| Fonctionnalité | Description |
|---|---|
| **Catalogue de produits** | Grille 2 colonnes avec image, nom, prix, catégorie. Chargement asynchrone simulé avec `FutureProvider`. |
| **Détail produit** | Écran dédié avec SliverAppBar, Hero animation, description, bouton ajout panier, icône favori. |
| **Panier d'achat** | Ajout, suppression, quantité modifiable (+/-), sous-total par ligne, total général. Badge dynamique sur l'icône panier. |
| **Favoris persistés** | Sauvegarde locale via `shared_preferences`. Les favoris survivent au redémarrage de l'app. |
| **Filtrage & tri** | Filtrage par catégorie (chips), tri par prix croissant/décroissant et nom A-Z. |
| **Profil utilisateur** | Écran mock avec avatar, nom, email, résumé (articles au panier + favoris). |
| **Animations (bonus)** | Scale animation sur le bouton "Ajouter au panier", AnimatedSwitcher sur les icônes favori et les labels. |

---

## 🏗️ Architecture en couches

```
lib/
├── main.dart                          # Point d'entrée, ProviderScope, ThemeData, GoRouter
│
├── models/                            # Modèles de données (PODO)
│   ├── product.dart                   #   → Product (id, name, description, category, price, imageUrl)
│   └── cart_item.dart                 #   → CartItem (product, quantity, subtotal, copyWith)
│
├── data/                              # Couche données
│   └── product_repository.dart        #   → ProductRepository (fetchProducts avec Future.delayed)
│
├── providers/                         # Tous les providers Riverpod
│   ├── products_provider.dart         #   → productsProvider (FutureProvider)
│   ├── cart_provider.dart             #   → cartProvider (StateNotifierProvider)
│   ├── favorites_provider.dart        #   → favoritesProvider (StateNotifierProvider + shared_preferences)
│   ├── product_filter_provider.dart   #   → productFilterProvider (StateNotifierProvider)
│   └── derived_providers.dart         #   → filteredProductsProvider, cartTotalProvider, cartItemCountProvider
│
├── screens/                           # Écrans de l'application
│   ├── product_list_screen.dart       #   → Catalogue avec grille + FilterSortBar
│   ├── product_detail_screen.dart     #   → Détail produit avec SliverAppBar + Hero
│   ├── cart_screen.dart               #   → Panier avec total et bouton commande
│   ├── favorites_screen.dart          #   → Liste des favoris
│   └── profile_screen.dart            #   → Profil utilisateur mock
│
└── widgets/                           # Widgets réutilisables
    ├── product_card.dart              #   → Carte produit (grille) avec animation ajout panier
    ├── cart_item_tile.dart            #   → Ligne panier (+/-, supprimer, sous-total)
    └── filter_sort_bar.dart           #   → Chips catégorie + dropdown tri
```

### Séparation des responsabilités

- **`models/`** — Classes de données pures, sans dépendance Flutter.
- **`data/`** — Repository simulant un appel réseau avec `Future.delayed(1500ms)`.
- **`providers/`** — Toute la logique métier et le state management (aucun provider dans les widgets).
- **`screens/`** — Écrans composant les widgets et consommant les providers via `ref.watch` / `ref.read`.
- **`widgets/`** — Composants UI réutilisables, responsables de leur propre style.

---

## 🔌 Providers Riverpod (6 au total)

| # | Provider | Type | Rôle |
|---|---------|------|------|
| 1 | `productsProvider` | `FutureProvider<List<Product>>` | Charge la liste des produits de manière asynchrone (simule un appel API avec `Future.delayed`). |
| 2 | `cartProvider` | `StateNotifierProvider<CartNotifier, List<CartItem>>` | Gère le panier : ajout, suppression, incrémentation/décrémentation de quantité. |
| 3 | `favoritesProvider` | `StateNotifierProvider<FavoritesNotifier, Set<String>>` | Gère les favoris avec persistance locale via `shared_preferences`. |
| 4 | `productFilterProvider` | `StateNotifierProvider<ProductFilterNotifier, FilterState>` | Stocke la catégorie sélectionnée et le critère de tri. |
| 5 | `filteredProductsProvider` | `Provider<AsyncValue<List<Product>>>` | Provider dérivé combinant `productsProvider` + `productFilterProvider`. Utilise `whenData()` pour filtrer et trier. |
| 6 | `cartTotalProvider` | `Provider<double>` | Provider dérivé calculant le montant total du panier. |
| (6b) | `cartItemCountProvider` | `Provider<int>` | Provider dérivé comptant le nombre total d'articles (pour le badge). |

### Utilisation dans les widgets

- **`ref.watch(provider)`** — Lecture réactive (rebuild automatique quand l'état change).
- **`ref.read(provider.notifier)`** — Actions ponctuelles (ajout au panier, toggle favori).
- **`AsyncValue.when(data:, loading:, error:)`** — Gestion des 3 états partout où `productsProvider` est consommé.
- **`ConsumerWidget`** / **`ConsumerStatefulWidget`** — Tous les widgets qui lisent un provider héritent de ces classes.

---

## 🎨 Design & UX

- **Material 3** avec `useMaterial3: true` et `ColorScheme.fromSeed(Color(0xFF006D77))`
- **NavigationBar** Material 3 avec badge dynamique sur l'onglet Panier
- **Hero animation** entre la carte produit et l'écran de détail
- **Scale animation** sur le bouton "Ajouter au panier" (bonus)
- **AnimatedSwitcher** sur les icônes favori (transition fluide rouge ↔ contour)
- **SnackBar** avec action "Voir le panier" à chaque ajout
- **États vides** soignés (icône + texte + bouton CTA "Découvrir les produits")
- **Images** via `picsum.photos` avec `loadingBuilder` et `errorBuilder`
- **Cards** à coins arrondis (14px), légère élévation, effet InkWell/ripple

---

## 🚀 Installation & Lancement

### Prérequis
- Flutter SDK ≥ 3.13
- Chrome (pour le web) ou un émulateur Android/iOS

### Commandes

```bash
# Cloner le repo
git clone https://github.com/diaoumardia2001-beep/ecommerce-app-riverpod.git
cd ecommerce-app-riverpod

# Installer les dépendances
flutter pub get

# Lancer sur Chrome
flutter run -d chrome

# Ou sur un émulateur Android
flutter run -d android

# Ou sur Windows desktop
flutter run -d windows
```

---

## 📦 Dépendances

| Package | Version | Rôle |
|---------|---------|------|
| `flutter_riverpod` | ^3.4.3 | State management (providers, notifiers) |
| `shared_preferences` | ^2.5.5 | Persistance locale des favoris |
| `go_router` | ^14.8.1 | Navigation déclarative + ShellRoute pour BottomNavigationBar |

---

## 📁 Données mockées

10 produits répartis en 3 catégories (**Vêtements**, **Électronique**, **Maison**) avec des noms, descriptions et prix réalistes. Le chargement simule un appel réseau avec un délai de 1,5 seconde.

---

## ✅ Checklist du projet

- [x] Catalogue de produits (liste + détail)
- [x] Panier d'achat (ajout, suppression, quantité)
- [x] Système de favoris persisté localement
- [x] Filtrage et tri des produits
- [x] Écran de profil utilisateur (mock)
- [x] Utilisation exclusive de Riverpod
- [x] Au moins 5 providers distincts (6 + 1 bonus)
- [x] Architecture en couches séparée
- [x] Gestion des états de chargement et d'erreur
- [x] Utilisation d'AsyncValue.when()
- [x] Données produits mockées
- [x] **Bonus** : animations sur l'ajout au panier (ScaleTransition + AnimatedSwitcher)
- [x] Repo GitHub public avec README détaillé
