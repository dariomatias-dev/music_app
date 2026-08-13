import 'package:flutter_test/flutter_test.dart';
import 'package:music_app/src/features/queue/data/playback_session_storage.dart';
import 'package:music_app/src/features/queue/domain/playback_session.dart';

import '../../../helpers/fake_key_value_storage.dart';

void main() {
  late FakeKeyValueStorage storage;
  late PlaybackSessionStorage sessionStorage;

  setUp(() {
    storage = FakeKeyValueStorage();
    sessionStorage = PlaybackSessionStorage(storage);
  });

  test('load returns null when nothing was saved', () async {
    expect(await sessionStorage.load(), isNull);
  });

  test('a saved session survives a round trip', () async {
    const session = PlaybackSession(
      trackIds: ['track-1', 'track-2'],
      currentIndex: 1,
      position: Duration(seconds: 42),
    );

    await sessionStorage.save(session);
    final loaded = await sessionStorage.load();

    expect(loaded?.trackIds, session.trackIds);
    expect(loaded?.currentIndex, session.currentIndex);
    expect(loaded?.position, session.position);
  });

  test('clear removes the saved session', () async {
    const session = PlaybackSession(
      trackIds: ['track-1'],
      currentIndex: 0,
      position: Duration.zero,
    );
    await sessionStorage.save(session);

    await sessionStorage.clear();

    expect(await sessionStorage.load(), isNull);
  });
}
