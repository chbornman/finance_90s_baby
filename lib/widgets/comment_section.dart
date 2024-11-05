import 'package:flutter/material.dart';
import '../api/database_api.dart';

class CommentSection extends StatelessWidget {
  final String lessonId;
  final String userId; // Add the user ID parameter here
  final DatabaseAPI databaseAPI;

  const CommentSection({
    super.key,
    required this.lessonId,
    required this.userId,
    required this.databaseAPI,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Add a comment'),
          onSubmitted: (text) {
            databaseAPI.addComment(lessonId, userId, text);
          },
        ),
        // List existing comments for the lesson here
      ],
    );
  }
}