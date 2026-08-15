import 'package:music_app/src/features/library/presentation/providers/library_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

/// The Home tab's overall state, driven by whether the library has been
/// indexed yet.
enum HomeState {
  /// The library index hasn't reported yet.
  loading,

  /// Nothing is indexed.
  empty,

  /// At least one track is indexed; the Home sections have something to
  /// show.
  ready,
}

/// The Home tab's current state.
@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    final tracks = ref.watch(tracksStreamProvider);
    return tracks.when(
      data: (tracks) => tracks.isEmpty ? HomeState.empty : HomeState.ready,
      loading: () => HomeState.loading,
      error: (error, stackTrace) => HomeState.empty,
    );
  }
}
