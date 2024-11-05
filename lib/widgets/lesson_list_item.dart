import 'package:flutter/material.dart';
class LessonListItem extends StatelessWidget {
  final Map<String, dynamic> lesson; // Accept Map<String, dynamic>

  const LessonListItem({Key? key, required this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson['title'] ?? 'No Title'), // Display title from Map
      subtitle: Text(lesson['fileUrl'] ?? 'No URL'), // Display file URL or other fields as needed
      // You can customize this widget further based on your lesson data structure
    );
  }
}