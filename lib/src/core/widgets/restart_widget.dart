import 'package:flutter/widgets.dart';

/// Wraps [child] so any descendant can force the whole subtree to be torn
/// down and rebuilt from scratch via [restartApp].
///
/// Used after a database restore: every provider (including the database
/// connection itself) needs to be recreated against the restored file
/// rather than keep serving state read from the one it replaced.
class RestartWidget extends StatefulWidget {
  /// Creates a [RestartWidget] wrapping [child].
  const RestartWidget({required this.child, super.key});

  /// The wrapped subtree, rebuilt from scratch on [restartApp].
  final Widget child;

  /// Rebuilds the nearest [RestartWidget] ancestor's subtree from scratch.
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?._restart();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key _key = UniqueKey();

  void _restart() => setState(() => _key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: _key, child: widget.child);
  }
}
