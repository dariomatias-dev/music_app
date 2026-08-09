import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/music_app.dart';

void main() {
  testWidgets('MusicApp builds without throwing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MusicApp()));

    expect(find.byType(MusicApp), findsOneWidget);
  });
}
