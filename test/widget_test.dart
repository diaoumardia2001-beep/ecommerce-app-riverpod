import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecommerce_app/main.dart';

void main() {
  testWidgets('App launches and shows ShopEase title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: EcommerceApp()),
    );

    // The AppBar should display our brand name
    expect(find.text('ShopEase'), findsOneWidget);
  });
}
