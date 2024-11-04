import 'package:finance_90s_baby/constants.dart';
import 'package:flutter/material.dart';
import '../api/database_api.dart';
import '../api/storage_api.dart';
import '../widgets/lesson_list_item.dart';

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
    // Step 1: Select a file to upload
    final pickedFile = await widget.storageAPI.pickFile();
    if (pickedFile == null) return;

    // Step 2: Upload the file to storage
    final fileId = await widget.storageAPI.uploadFile(pickedFile);
    if (fileId == null) return;

    // Step 3: Construct a URL to access the file
    final fileUrl =
        '${AppConstants.appwriteEndpoint}/storage/buckets/${AppConstants.bucketIdLessonContent}/files/$fileId/view?project=${AppConstants.projectId}';

    // Step 4: Update the database with the new lesson data
    await widget.databaseAPI.addLesson({
      'fileUrl': fileUrl,
      'title': 'New Lesson',
      // add other fields as needed
    });

    // Step 5: Refresh the UI to show the updated list
    setState(() {});
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
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          final lessons = snapshot.data!;
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              return LessonListItem(
                lesson: lessons[index],
              );
            },
          );
        },
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: _uploadLesson,
              tooltip: 'Upload Lesson',
              child: const Icon(Icons.upload_file),
            )
          : FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/feedback');
              },
              tooltip: 'Give thoughts and feedback',
              child: const Icon(Icons.feedback),
            ),
    );
  }
}
