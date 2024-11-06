import 'package:finance_90s_baby/api/database_api.dart';
import 'package:finance_90s_baby/log_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownViewer extends StatefulWidget {
  final String title;
  final String content;
  bool isCompleted;
  final DatabaseAPI databaseAPI;
  final String userId;
  final String lessonId;
  final Future<void> Function() onComplete;

  MarkdownViewer({
    required this.title,
    required this.content,
    required this.isCompleted,
    required this.databaseAPI,
    required this.userId,
    required this.lessonId,
    required this.onComplete,
  });

  @override
  _MarkdownViewerState createState() => _MarkdownViewerState();
}

class _MarkdownViewerState extends State<MarkdownViewer> {
  final ScrollController _scrollController = ScrollController();

  void _leaveCommentOnLesson() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String commentText = '';
        return AlertDialog(
          title: Text('Leave a Comment'),
          content: TextField(
            onChanged: (value) {
              commentText = value;
            },
            decoration: InputDecoration(hintText: 'Enter your comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.databaseAPI
                    .addComment(widget.lessonId, widget.userId, commentText);
                Navigator.of(context).pop();
              },
              child: Text('Submit Comment'),
            ),
          ],
        );
      },
    );
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
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.isCompleted)
                FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  heroTag: 'completeButton',
                  onPressed: () async {
                    await widget.onComplete();
                    setState(() {
                      widget.isCompleted = true;
                    });
                  },
                  child: Icon(Icons.check),
                ),
              SizedBox(width: 16), // Add some space between the buttons
              FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                heroTag: 'commentButton',
                onPressed: _leaveCommentOnLesson,
                child: Icon(Icons.comment),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
