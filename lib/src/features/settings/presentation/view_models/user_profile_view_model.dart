import 'package:music_app/src/core/constants/preference_keys.dart';
import 'package:music_app/src/core/storage/storage_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_profile_view_model.g.dart';

/// The user's display name, shown in the Home greeting.
///
/// A `null` value means none was ever set (editing it is built in
/// Etapa 91); Home falls back to a name-less greeting.
@riverpod
class UserProfileViewModel extends _$UserProfileViewModel {
  @override
  Future<String?> build() {
    return ref
        .read(keyValueStorageProvider)
        .getString(
          PreferenceKeys.userDisplayName,
        );
  }

  /// Sets the display name, persisting the choice. An empty [name] clears
  /// it.
  Future<void> setDisplayName(String name) async {
    final trimmed = name.trim();
    final storage = ref.read(keyValueStorageProvider);
    if (trimmed.isEmpty) {
      await storage.remove(PreferenceKeys.userDisplayName);
      state = const AsyncData(null);
      return;
    }
    await storage.setString(PreferenceKeys.userDisplayName, trimmed);
    state = AsyncData(trimmed);
  }
}
