import 'package:flutter/material.dart';

import '../utils/riverpod_framework.dart';

class CustomSearchBarController {
  final TextEditingController textController = TextEditingController();
  VoidCallback? _closeCallback;

  String get query => textController.text;
  set query(String value) => textController.text = value;

  void close() => _closeCallback?.call();
  void clear() => textController.clear();

  void dispose() {
    textController.dispose();
  }
}

CustomSearchBarController useFloatingSearchBarController() {
  return use(const _FloatingSearchBarControllerHook());
}

class _FloatingSearchBarControllerHook extends Hook<CustomSearchBarController> {
  const _FloatingSearchBarControllerHook();

  @override
  _FloatingSearchBarControllerState createState() =>
      _FloatingSearchBarControllerState();
}

class _FloatingSearchBarControllerState
    extends HookState<CustomSearchBarController, _FloatingSearchBarControllerHook> {
  final _controller = CustomSearchBarController();

  @override
  CustomSearchBarController build(BuildContext context) => _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
