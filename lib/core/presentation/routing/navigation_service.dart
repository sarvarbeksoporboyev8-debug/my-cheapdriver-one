import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_toast.dart';

abstract class NavigationService {
  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static void _closeOverlays() {
    CustomToast.removeToast();
  }

  static Future<void> pop<T>(
    BuildContext context, {
    T? result,
    bool closeOverlays = false,
  }) async {
    if (closeOverlays) {
      _closeOverlays();
    }
    if (context.canPop()) {
      return context.pop(result);
    }
  }

  static Future<void> popDialog<T extends Object?>(
    BuildContext context, {
    T? result,
  }) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      return navigator.pop(result);
    }
  }
}
