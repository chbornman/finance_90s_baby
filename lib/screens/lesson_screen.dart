import 'package:flutter/material.dart';
import '../api/storage_api.dart';
import '../api/database_api.dart';
import '../widgets/comment_section.dart';

class LessonScreen extends StatelessWidget {
  final StorageAPI storageAPI;
  final DatabaseAPI databaseAPI;
  final Map<String, dynamic> lesson;

  const LessonScreen({super.key, 
    required this.storageAPI,
    required this.databaseAPI,
    required this.lesson,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson['title'])),
      body: FutureBuilder<String>(
        future: storageAPI.getLessonContent(lesson['fileId']).then((value) => value ?? ''),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.data!, style: const TextStyle(fontSize: 16)),
                CommentSection(
                  lessonId: lesson['\$id'],
                  databaseAPI: databaseAPI, // Pass databaseAPI here
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}