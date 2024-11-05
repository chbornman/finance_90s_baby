import 'package:finance_90s_baby/constants.dart';
import 'package:finance_90s_baby/log_service.dart';
import 'package:finance_90s_baby/markdown_utilities.dart';
import 'package:flutter/material.dart';
import '../api/database_api.dart';
import '../api/storage_api.dart';
import '../widgets/lesson_list_item.dart';
import 'lesson_screen.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseAPI databaseAPI;
  final StorageAPI storageAPI;

  const HomeScreen(this.databaseAPI, this.storageAPI, {super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAdmin = false;

  void _toggleMode() {
    setState(() {
      isAdmin = !isAdmin;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Course'),
        actions: [
          IconButton(
            icon: Icon(isAdmin ? Icons.admin_panel_settings : Icons.person),
            onPressed: _toggleMode,
            tooltip: isAdmin ? 'Switch to User Mode' : 'Switch to Admin Mode',
          ),
        ],
      ),
      body: FutureBuilder<List>(
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
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonScreen(
                        storageAPI: widget.storageAPI,
                        databaseAPI: widget.databaseAPI,
                        lesson: lesson,
                        userId: '',
                      ),
                    ),
                  );
                },
                child: LessonListItem(
                  lesson: lesson,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: "uploadButton", // Unique heroTag
                  onPressed: _uploadLesson,
                  tooltip: 'Upload Lesson',
                  child: const Icon(Icons.upload_file),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: "deleteButton", // Unique heroTag
                  onPressed: _deleteLessonDialog,
                  tooltip: 'Delete Lesson',
                  child: const Icon(Icons.delete),
                ),
              ],
            )
          : FloatingActionButton(
              heroTag: "feedbackButton", // Unique heroTag for non-admin button
              onPressed: () {
                Navigator.pushNamed(context, '/feedback');
              },
              tooltip: 'Give thoughts and feedback',
              child: const Icon(Icons.feedback),
            ),
    );
  }
}
