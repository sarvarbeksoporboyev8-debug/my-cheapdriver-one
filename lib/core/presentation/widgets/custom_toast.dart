import 'package:flutter/material.dart';

import '../../core_features/theme/presentation/utils/app_static_colors.dart';
import '../styles/styles.dart';

abstract class CustomToast {
  static OverlayEntry? _currentToast;

  static void showToast(
    BuildContext context, {
    Widget? child,
    Color? backgroundColor,
    double? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
    Duration toastDuration = const Duration(seconds: 3),
  }) {
    removeToast();

    final overlay = Overlay.of(context);
    final toast = Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(borderRadius ?? Sizes.dialogR20),
      ),
      margin: margin,
      padding: padding ??
          const EdgeInsets.symmetric(
            vertical: Sizes.paddingV14,
            horizontal: Sizes.paddingH20,
          ),
      child: child,
    );

    _currentToast = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        left: 0,
        right: 0,
        child: Center(
          child: Material(color: Colors.transparent, child: toast),
        ),
      ),
    );

    overlay.insert(_currentToast!);
    Future.delayed(toastDuration, removeToast);
  }

  static void removeToast() {
    _currentToast?.remove();
    _currentToast = null;
  }

  static Future<void> showBackgroundToast(
    BuildContext context, {
    String msg = '',
    Color? backgroundColor,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: TextStyle(
                fontSize: Sizes.font16, color: AppStaticColors.lightBlack)),
        backgroundColor: backgroundColor ?? AppStaticColors.toastColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
