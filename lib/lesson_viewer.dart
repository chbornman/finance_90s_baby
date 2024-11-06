import 'package:finance_90s_baby/api/auth_api.dart';
import 'package:finance_90s_baby/api/database_api.dart';
import 'package:finance_90s_baby/lesson_comment_section.dart';
import 'package:finance_90s_baby/markdown_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LessonViewer extends StatefulWidget {
  final String content;
  bool isCompleted;
  final DatabaseAPI databaseAPI;
  final AuthAPI authAPI;
  final String userId;
  final String lessonId;
  final Future<void> Function() onComplete;

  LessonViewer({
    required this.content,
    required this.isCompleted,
    required this.databaseAPI,
    required this.authAPI,
    required this.userId,
    required this.lessonId,
    required this.onComplete,
  });

  @override
  _LessonViewerState createState() => _LessonViewerState();
}

class _LessonViewerState extends State<LessonViewer> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: widget.databaseAPI.getLessonTitle(widget.lessonId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error');
            } else {
              return Text(snapshot.data ?? 'No Title');
            }
          },
        ),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonCommentSection(
                        databaseAPI: widget.databaseAPI,
                        lessonId: widget.lessonId,
                        userId: widget.userId,
                        authAPI: widget.authAPI,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.comment),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
