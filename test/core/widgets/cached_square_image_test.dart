import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/widgets/cached_square_image.dart';

void main() {
  testWidgets(
    'decodes at the display size scaled by the device pixel ratio, not '
    'the source resolution',
    (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(devicePixelRatio: 3),
          child: MaterialApp(
            home: Scaffold(
              body: CachedSquareImage(path: '/music/cover.jpg', size: 44),
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      final resizeImage = image.image as ResizeImage;

      // 44 logical pixels at a 3x device pixel ratio.
      expect(resizeImage.width, 132);
      expect(resizeImage.height, 132);
      expect(image.width, 44);
      expect(image.height, 44);
      expect(image.fit, BoxFit.cover);
    },
  );
}
