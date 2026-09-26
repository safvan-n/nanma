import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nanma/main.dart';

void main() {
  testWidgets('NanmaApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: NanmaApp(),
      ),
    );
    // Settle splash timer
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.byType(NanmaApp), findsOneWidget);
  });
}
