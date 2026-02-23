import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:advanced_highlight_text/advanced_highlight_text.dart';

void main() {
  testWidgets('Plain highlight works',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AdvancedHighlightText(
            text: 'Flutter is amazing',
            highlights: [
              Highlight(pattern: 'Flutter'),
            ],
          ),
        ),
      ),
    );

    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsOneWidget);

    final RichText richText =
        tester.widget(richTextFinder);

    final TextSpan span = richText.text as TextSpan;

    final combinedText = _extractText(span);

    expect(combinedText, contains('Flutter'));
  });

  testWidgets('Regex highlight works',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AdvancedHighlightText(
            text: 'Email test@mail.com',
            highlights: [
              Highlight(
                pattern:
                    r'\b[\w\.-]+@[\w\.-]+\.\w+\b',
                isRegex: true,
              ),
            ],
          ),
        ),
      ),
    );

    final richTextFinder = find.byType(RichText);
    expect(richTextFinder, findsOneWidget);

    final RichText richText =
        tester.widget(richTextFinder);

    final TextSpan span = richText.text as TextSpan;

    final combinedText = _extractText(span);

    expect(combinedText, contains('@'));
  });
}

String _extractText(TextSpan span) {
  final buffer = StringBuffer();

  void visit(TextSpan span) {
    if (span.text != null) {
      buffer.write(span.text);
    }
    if (span.children != null) {
      for (final child in span.children!) {
        visit(child as TextSpan);
      }
    }
  }

  visit(span);

  return buffer.toString();
}