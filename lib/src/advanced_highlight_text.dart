import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'highlight.dart';

class AdvancedHighlightText extends StatefulWidget {
  final String text;
  final List<Highlight> highlights;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool caseSensitive;

  const AdvancedHighlightText({
    super.key,
    required this.text,
    required this.highlights,
    this.style,
    this.textAlign = TextAlign.start,
    this.caseSensitive = false,
  });

  @override
  State<AdvancedHighlightText> createState() =>
      _AdvancedHighlightTextState();
}

class _AdvancedHighlightTextState
    extends State<AdvancedHighlightText> {
  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    _recognizers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle =
        widget.style ?? DefaultTextStyle.of(context).style;

    final spans = _buildSpans(baseStyle);

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }

  List<TextSpan> _buildSpans(TextStyle baseStyle) {
    if (widget.highlights.isEmpty) {
      return [TextSpan(text: widget.text)];
    }

    final Map<int, Highlight> groupMap = {};
    final buffer = StringBuffer();

    for (int i = 0; i < widget.highlights.length; i++) {
      final h = widget.highlights[i];
      final pattern =
          h.isRegex ? h.pattern : RegExp.escape(h.pattern);

      if (i != 0) buffer.write('|');
      buffer.write('($pattern)');
      groupMap[i + 1] = h;
    }

    final regExp = RegExp(
      buffer.toString(),
      caseSensitive: widget.caseSensitive,
    );

    final matches = regExp.allMatches(widget.text);

    if (matches.isEmpty) {
      return [TextSpan(text: widget.text)];
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text:
                widget.text.substring(currentIndex, match.start),
          ),
        );
      }

      Highlight? matchedHighlight;

      for (int i = 1;
          i <= widget.highlights.length;
          i++) {
        if (match.group(i) != null) {
          matchedHighlight = groupMap[i];
          break;
        }
      }

      final matchedText =
          widget.text.substring(match.start, match.end);

      if (matchedHighlight != null) {
        TapGestureRecognizer? recognizer;

        if (matchedHighlight.onTap != null) {
          recognizer = TapGestureRecognizer()
            ..onTap = () =>
                matchedHighlight!.onTap!(matchedText);

          _recognizers.add(recognizer);
        }

        spans.add(
          TextSpan(
            text: matchedText,
            style:
                matchedHighlight.resolveStyle(baseStyle),
            recognizer: recognizer,
          ),
        );
      } else {
        spans.add(TextSpan(text: matchedText));
      }

      currentIndex = match.end;
    }

    if (currentIndex < widget.text.length) {
      spans.add(
        TextSpan(
          text: widget.text.substring(currentIndex),
        ),
      );
    }

    return spans;
  }
}