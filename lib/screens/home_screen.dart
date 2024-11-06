import 'package:finance_90s_baby/constants.dart';
import 'package:finance_90s_baby/log_service.dart';
import 'package:finance_90s_baby/markdown_utilities.dart';
import 'package:finance_90s_baby/lesson_viewer.dart';
import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../api/database_api.dart';
import '../api/storage_api.dart';
import '../widgets/lesson_list_item.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseAPI databaseAPI;
  final StorageAPI storageAPI;
  final AuthAPI authAPI;
  final String userRole;
  final String userId;

  const HomeScreen(this.databaseAPI, this.storageAPI, this.authAPI,
      {super.key, required this.userRole, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _signOut() async {
    await widget.authAPI.logoutUser(); // Perform sign-out
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigate to login screen
  }

  Future<void> _uploadLesson() async {
    final pickedFile = await widget.storageAPI.pickFile();
    if (pickedFile == null) return;

    final fileId = await widget.storageAPI.uploadFile(pickedFile);
    if (fileId == null) return;

    final fileUrl =
        '${AppConstants.appwriteEndpoint}/storage/buckets/${AppConstants.bucketIdLessonContent}/files/$fileId/view?project=${AppConstants.projectId}';

    final lessonData = await widget.storageAPI.getLessonContent(fileId);
    final title = extractTitleFromMarkdown(lessonData!);

    await widget.databaseAPI.addLesson(
      fileUrl: fileUrl,
      title: title,
      fileId: fileId,
    );

    LogService.instance.info("fileUrl: $fileUrl");
    LogService.instance.info("File title extracted: $title");

    setState(() {});
  }

  Future<void> _deleteLessonDialog() async {
    List<Map<String, dynamic>> lessons = await widget.databaseAPI.getLessons();

    String? selectedLessonId;
    String? selectedFileId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Lesson"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Select Lesson"),
                items: lessons.map((lesson) {
                  return DropdownMenuItem<String>(
                    value: lesson['\$id'],
                    child: Text(lesson['title'] ?? 'Untitled Lesson'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLessonId = value;
                    selectedFileId = lessons.firstWhere(
                        (lesson) => lesson['\$id'] == value)['fileId'];
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                LogService.instance.info("pressed Delete button");
                if (selectedLessonId != null && selectedFileId != null) {
                  await _deleteLesson(selectedLessonId!, selectedFileId!);
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteLesson(String lessonId, String fileId) async {
    try {
      await widget.databaseAPI.deleteLesson(lessonId);
      await widget.storageAPI.deleteFile(fileId);
      LogService.instance.info("Lesson and file deleted successfully.");
    } catch (e) {
      LogService.instance.error("Error deleting lesson or file: $e");
    }
  }

  Future<bool> _getLessonCompletionStatus(String lessonId) async {
    return await widget.databaseAPI.isLessonCompleted(widget.userId, lessonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("90's Baby Finance"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut, // Sign out when pressed
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: widget.databaseAPI.getLessons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final lessons = snapshot.data!;
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index];

              return FutureBuilder<bool>(
                future: _getLessonCompletionStatus(lesson['\$id']),
                builder: (context, completedSnapshot) {
                  if (!completedSnapshot.hasData) {
                    return const ListTile(
                      title: Text("Loading..."),
                    );
                  }
                  lesson['completed'] = completedSnapshot.data;

                  return InkWell(
                    onTap: () async {
                      final content = await widget.storageAPI
                          .getLessonContent(lesson['fileId']);
                      if (content != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LessonViewer(
                              content: content,
                              title: 'Lesson Viewer',
                              lessonId: lesson['\$id'],
                              userId: widget.userId,
                              isCompleted: lesson['completed'] ?? false,
                              databaseAPI: widget.databaseAPI,
                              onComplete: () async {
                                await widget.databaseAPI
                                    .markLessonCompletedUserProgress(
                                        widget.userId, lesson['\$id'], true);
                                LogService.instance
                                    .info("Lesson marked as complete.");
                                setState(() {
                                  lesson['completed'] = true;
                                });
                                Navigator.pop(context); // Return to HomeScreen
                              },
                            ),
                          ),
                        );
                      } else {
                        LogService.instance
                            .error("Failed to load lesson content.");
                      }
                    },
                    child: LessonListItem(
                      lesson: lesson,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: widget.userRole == "admin"
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  heroTag: "uploadButton",
                  onPressed: _uploadLesson,
                  tooltip: 'Upload Lesson',
                  child: const Icon(Icons.upload_file),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  heroTag: "deleteButton",
                  onPressed: _deleteLessonDialog,
                  tooltip: 'Delete Lesson',
                  child: const Icon(Icons.delete),
                ),
              ],
            )
          : FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              heroTag: "commentsButton",
              onPressed: () {
                Navigator.pushNamed(context, '/comments');
              },
              tooltip: 'Give thoughts and comments',
              child: const Icon(Icons.feedback),
            ),
    );
  }
}
