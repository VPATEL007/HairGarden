import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// State of the snackbar
/// Setting this will set the background color of the snackbar
enum SnackbarState {
  /// For Information message
  info,

  /// For Warning message
  warning,

  /// For Danger message
  danger,

  /// For Success message
  success,

  /// Default state of the message
  defaultState,
}

/// App themed snackbar
void appSnackbar({
  required String message,
  SnackbarState snackbarState = SnackbarState.defaultState,
}) {
  Get.rawSnackbar(
    icon: Icon(
      _snackbarIcon(snackbarState),
      color: Colors.white,
    ),
    margin: const EdgeInsets.all(8),
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: _snackbarColor(snackbarState),
    borderRadius: 12,
    duration: const Duration(seconds: 2),
  );
}

Color _snackbarColor(SnackbarState snackbarState) {
  switch (snackbarState) {
    case SnackbarState.info:
      return Colors.blue;
    case SnackbarState.warning:
      return Colors.orangeAccent;
    case SnackbarState.danger:
      return Colors.red;
    case SnackbarState.defaultState:
      return Colors.black;
    case SnackbarState.success:
      return Colors.green;
    default:
      return Colors.black;
  }
}

IconData _snackbarIcon(SnackbarState snackbarState) {
  switch (snackbarState) {
    case SnackbarState.info:
      return Icons.info;
    case SnackbarState.warning:
      return Icons.warning;
    case SnackbarState.danger:
      return Icons.error;
    case SnackbarState.defaultState:
      return Icons.notifications_active;
    case SnackbarState.success:
      return Icons.check_circle;
    default:
      return Icons.check_circle;
  }
}