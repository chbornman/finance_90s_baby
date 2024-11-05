import 'package:flutter/material.dart';

class LessonListItem extends StatelessWidget {
  final Map<String, dynamic> lesson;

  const LessonListItem({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson['title'] ?? 'No Title'),
      trailing: Checkbox(
        value: lesson['completed'] ?? false,
        onChanged: null, // Set onChanged to null to make it read-only
      ),
    );
  }
}