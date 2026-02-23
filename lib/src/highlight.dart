import 'package:flutter/material.dart';

typedef HighlightTapCallback = void Function(String value);

@immutable
class Highlight {
  final String pattern;
  final TextStyle? textStyle;
  final Color? textColor;
  final Color? backgroundColor;
  final HighlightTapCallback? onTap;
  final bool isRegex;

  const Highlight({
    required this.pattern,
    this.textStyle,
    this.textColor,
    this.backgroundColor,
    this.onTap,
    this.isRegex = false,
  });

  TextStyle resolveStyle(TextStyle baseStyle) {
    TextStyle resolved = textStyle ?? baseStyle;

    if (textColor != null) {
      resolved = resolved.copyWith(color: textColor);
    }

    if (backgroundColor != null) {
      resolved = resolved.copyWith(backgroundColor: backgroundColor);
    }

    return resolved;
  }
}