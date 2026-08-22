import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const shadow = Color(0x33000000);

  test('none is an empty shadow list', () {
    expect(AppElevations.none, isEmpty);
  });

  test('low is a single contact shadow in the given color', () {
    final shadows = AppElevations.low(shadow);

    expect(shadows, hasLength(1));
    expect(shadows.single.color, shadow);
    expect(shadows.single.offset, const Offset(0, 1));
  });

  test('medium is a single shadow, softer and further down than low', () {
    final shadows = AppElevations.medium(shadow);

    expect(shadows, hasLength(1));
    expect(shadows.single.color, shadow);
    expect(
      shadows.single.blurRadius,
      greaterThan(AppElevations.low(shadow).single.blurRadius),
    );
    expect(shadows.single.offset.dy, greaterThan(1));
  });

  test('high layers a contact shadow under a wider ambient one', () {
    final shadows = AppElevations.high(shadow);

    expect(shadows, hasLength(2));
    expect(shadows.every((boxShadow) => boxShadow.color == shadow), isTrue);
    expect(shadows.last.blurRadius, greaterThan(shadows.first.blurRadius));
    expect(shadows.last.offset.dy, greaterThan(shadows.first.offset.dy));
  });
}
