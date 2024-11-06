import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function() getLessons;
  final Future<void> Function(String lessonId, String userId, String commentText) addComment;
  final String userId;

  CommentDialog({required this.getLessons, required this.addComment, required this.userId});

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  String? selectedLessonId;
  String? selectedLessonName;
  String commentText = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Comment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: widget.getLessons(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading lessons');
              } else {
                final lessons = snapshot.data ?? [];
                return DropdownButton<String>(
                  hint: Text('Select a lesson'),
                  value: selectedLessonId,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLessonId = newValue;
                      selectedLessonName = lessons.firstWhere(
                          (lesson) => lesson['\$id'] == newValue)['title'];
                    });
                  },
                  items: lessons.map<DropdownMenuItem<String>>((lesson) {
                    return DropdownMenuItem<String>(
                      value: lesson['\$id'],
                      child: Text(lesson['title']),
                    );
                  }).toList(),
                );
              }
            },
          ),
          TextField(
            onChanged: (value) {
              commentText = value;
            },
            decoration: InputDecoration(hintText: 'Enter your comment'),
          ),
        ],
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
            if (selectedLessonId != null) {
              widget.addComment(selectedLessonId!, widget.userId, commentText);
            } else {
              widget.addComment('general', widget.userId, commentText);
            }
            Navigator.of(context).pop();
          },
          child: Text(selectedLessonId == null
              ? 'Submit general comment'
              : 'Submit comment for $selectedLessonName'),
        ),
      ],
    );
  }
}