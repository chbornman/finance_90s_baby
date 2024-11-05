import 'package:flutter/material.dart';
import '../api/storage_api.dart';
import '../api/database_api.dart';
import '../widgets/comment_section.dart';

class LessonScreen extends StatelessWidget {
  final StorageAPI storageAPI;
  final DatabaseAPI databaseAPI;
  final Map<String, dynamic> lesson; // Accept Map<String, dynamic>
  final String userId;

  const LessonScreen({
    Key? key,
    required this.storageAPI,
    required this.databaseAPI,
    required this.lesson,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lesson['title'] ?? 'Lesson')),
      body: FutureBuilder<String>(
        future: storageAPI
            .getLessonContent(
              lesson['fileId'],
            )
            .then((value) => value ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load lesson content."));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No content available."));
          }

          final lessonData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    lessonData,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                CommentSection(
                  lessonId: lesson['\$id'],
                  userId: userId,
                  databaseAPI: databaseAPI,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
