import 'package:finance_90s_baby/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownViewer extends StatelessWidget {
  final String content; // Markdown content as a String
  final String title; // Custom title for the AppBar

  MarkdownViewer({required this.content, required this.title});

  // Handler for opening links
  void _onTapLink(String? text, String? href, String title) async {
    if (href != null) {
      if (await canLaunch(href)) {
        await launch(href);
      } else {
        LogService.instance.error('Could not launch $href');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title), // Use the custom title here
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Markdown(
          data: content, // Displaying the Markdown content directly
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          onTapLink: _onTapLink, // Makes links clickable
        ),
      ),
    );
  }
}