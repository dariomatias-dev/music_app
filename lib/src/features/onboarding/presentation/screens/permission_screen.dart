import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:music_app/l10n/app_localizations.dart';
import 'package:music_app/src/core/navigation/route_paths.dart';
import 'package:music_app/src/core/permissions/media_permission_service.dart';
import 'package:music_app/src/core/permissions/permission_providers.dart';
import 'package:music_app/src/features/library/data/providers/library_data_providers.dart';

/// Explains why media access is needed, requests the permission, and
/// starts the first library scan once it is granted.
class PermissionScreen extends ConsumerStatefulWidget {
  /// Creates a [PermissionScreen].
  const PermissionScreen({super.key});

  @override
  ConsumerState<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends ConsumerState<PermissionScreen> {
  MediaPermissionStatus _status = MediaPermissionStatus.denied;
  var _isScanning = false;
  var _scanned = 0;
  int? _scanTotal;
  Object? _scanError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkStatus());
  }

  Future<void> _checkStatus() async {
    final status = await ref.read(mediaPermissionServiceProvider).check();
    if (!mounted) return;
    setState(() => _status = status);
    if (status == MediaPermissionStatus.granted) await _startScanAndContinue();
  }

  Future<void> _requestPermission() async {
    final status = await ref.read(mediaPermissionServiceProvider).request();
    if (!mounted) return;
    setState(() => _status = status);
    if (status == MediaPermissionStatus.granted) await _startScanAndContinue();
  }

  Future<void> _openSettings() async {
    await ref.read(mediaPermissionServiceProvider).openSystemSettings();
  }

  Future<void> _startScanAndContinue() async {
    setState(() {
      _isScanning = true;
      _scanned = 0;
      _scanTotal = null;
      _scanError = null;
    });

    try {
      await for (final progress
          in ref.read(libraryRepositoryProvider).reindex()) {
        if (!mounted) return;
        setState(() {
          _scanned = progress.processed;
          _scanTotal = progress.total;
        });
      }
      // The scan touches device files and metadata parsing outside our
      // control; any failure here should show a retry state, not crash.
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _isScanning = false;
        _scanError = error;
      });
      return;
    }

    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: _isScanning
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: AppIndexingProgress(
                    processedCount: _scanned,
                    totalCount: _scanTotal,
                    message: l10n.permissionScanning,
                  ),
                ),
              )
            : _scanError != null
            ? AppErrorState(
                icon: Icons.error_outline,
                title: l10n.scanErrorTitle,
                message: l10n.scanErrorMessage,
                retryLabel: l10n.retryLabel,
                onRetry: () => unawaited(_startScanAndContinue()),
                technicalDetails: _scanError.toString(),
              )
            : AppPermissionState(
                icon: Icons.perm_media_outlined,
                title: l10n.permissionTitle,
                message: l10n.permissionMessage,
                grantLabel: l10n.permissionGrant,
                onGrant: _requestPermission,
                isPermanentlyDenied:
                    _status == MediaPermissionStatus.permanentlyDenied,
                openSettingsLabel: l10n.permissionOpenSettings,
                onOpenSettings: _openSettings,
              ),
      ),
    );
  }
}
