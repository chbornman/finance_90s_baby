import 'package:flutter/material.dart';

class LessonListItem extends StatelessWidget {
  final Map<String, dynamic> lesson;

  const LessonListItem({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(lesson['title']),
      onTap: () {
        Navigator.pushNamed(context, '/lesson', arguments: lesson);
      },
    );
  }
}