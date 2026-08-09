import 'package:flutter/painting.dart';

/// The single type scale used across the app.
///
/// Every screen must build its text from these styles so that, for example,
/// a row in Search reads exactly like a row in Queue.
abstract final class AppTypography {
  /// Font family used across the app.
  static const fontFamily = 'Roboto';

  /// Upper bound applied to the system's text scale factor, so accessibility
  /// scaling does not break layouts.
  static const maxTextScaleFactor = 1.3;

  /// Big left-aligned page title (e.g. a screen's main heading).
  static const display = TextStyle(
    fontFamily: fontFamily,
    fontSize: 27,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.9,
    height: 1.1,
  );

  /// Centered title inside a top bar.
  static const appBar = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.35,
  );

  /// Large title inside a detail screen header.
  static const header = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.7,
    height: 1.15,
  );

  /// Section heading.
  static const section = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
  );

  /// Title of a list row.
  static const rowTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.5,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  /// Subtitle of a list row.
  static const rowSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5,
  );

  /// Metadata text, such as durations and counts, with tabular figures.
  static const meta = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Small, most de-emphasized text.
  static const caption = TextStyle(fontFamily: fontFamily, fontSize: 12);

  /// Text of a secondary interactive action.
  static const action = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
}
