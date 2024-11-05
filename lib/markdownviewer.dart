import 'package:finance_90s_baby/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownViewer extends StatefulWidget {
  final String content; // Markdown content as a String
  final String title; // Custom title for the AppBar
  final String lessonId; // ID of the lesson being viewed
  final String userId; // ID of the current user
  final bool isCompleted; // Flag to check if the lesson is already completed
  final void Function()?
      onComplete; // Callback when the lesson is marked as complete

  MarkdownViewer({
    required this.content,
    required this.title,
    required this.lessonId,
    required this.userId,
    required this.isCompleted,
    this.onComplete,
  });

  @override
  _MarkdownViewerState createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  final ScrollController _scrollController = ScrollController();
  bool _showCompleteButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // If content is less than viewport height or lesson is already complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isCompleted ||
          _scrollController.position.maxScrollExtent <= 0) {
        setState(() {
          _showCompleteButton = widget.isCompleted ? false : true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Detect if user has scrolled to the bottom
  void _onScroll() {
    if (!widget.isCompleted &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
      setState(() {
        _showCompleteButton = true;
      });
    }
  }

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

  // Mark the lesson as complete and navigate back to HomeScreen
  Future<void> _markLessonComplete() async {
    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Markdown(
                controller: _scrollController,
                data: widget.content,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
                onTapLink: _onTapLink,
              ),
            ),
          ),
          if (_showCompleteButton && !widget.isCompleted)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _markLessonComplete,
                child: const Text("Mark lesson as complete"),
              ),
            ),
        ],
      ),
    );
  }
}
