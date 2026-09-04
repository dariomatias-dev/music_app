import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/core/services/app_lifecycle/widgets_binding_app_lifecycle_service.dart';

void main() {
  late WidgetsBindingAppLifecycleService service;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    service = WidgetsBindingAppLifecycleService();
  });

  Future<void> sendState(AppLifecycleState state) async {
    TestWidgetsFlutterBinding.instance.handleAppLifecycleStateChanged(state);
    await Future<void>.delayed(Duration.zero);
  }

  test('emits the states the binding reports', () async {
    final emitted = <AppLifecycleState>[];
    final subscription = service.states.listen(emitted.add);
    addTearDown(subscription.cancel);

    await sendState(AppLifecycleState.inactive);
    await sendState(AppLifecycleState.hidden);
    await sendState(AppLifecycleState.paused);

    expect(emitted, [
      AppLifecycleState.inactive,
      AppLifecycleState.hidden,
      AppLifecycleState.paused,
    ]);
  });

  test('stops emitting once disposed', () async {
    final emitted = <AppLifecycleState>[];
    final subscription = service.states.listen(emitted.add);
    addTearDown(subscription.cancel);

    service.dispose();
    await sendState(AppLifecycleState.inactive);

    expect(emitted, isEmpty);
  });
}
