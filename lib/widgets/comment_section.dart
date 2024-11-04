import 'package:flutter/material.dart';
import '../api/database_api.dart';

class CommentSection extends StatelessWidget {
  final String lessonId;
  final DatabaseAPI databaseAPI;

  const CommentSection({super.key, required this.lessonId, required this.databaseAPI});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Add a comment'),
          onSubmitted: (text) {
            databaseAPI.addComment(lessonId, text);
          },
        ),
        // List existing comments for the lesson here
      ],
    );
  }
}