import 'package:flutter/material.dart';
import 'package:advanced_highlight_text/advanced_highlight_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Highlight Demo')),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: AdvancedHighlightText(
            text:
                "Flutter is amazing. Visit flutter.dev or email test@mail.com",
            highlights: [
              Highlight(
                pattern: "Flutter",
                textColor: Colors.blue,
                backgroundColor: Colors.yellow,
                onTap: (value) {
                  debugPrint("Tapped: $value");
                },
              ),
              Highlight(
                pattern: r"\bflutter\.dev\b",
                isRegex: true,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              ),
              Highlight(
                pattern:
                    r"\b[\w\.-]+@[\w\.-]+\.\w+\b",
                isRegex: true,
                textColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}