import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class LessonListItem extends StatelessWidget {
  final Document lesson; // Update this to expect Document type

  const LessonListItem({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson.data['title'] ?? 'Untitled'),
      // Additional data access from lesson.data
    );
  }
}