import 'package:flutter/material.dart';

extension GetArguments on BuildContext {
  T? get_arguments<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) return args as T;
    } else {
      return null;
    }
  }
}
