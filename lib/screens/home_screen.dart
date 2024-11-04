import 'package:flutter/material.dart';
import '../api/database_api.dart';
import '../widgets/lesson_list_item.dart';

class HomeScreen extends StatelessWidget {
  final DatabaseAPI databaseAPI;

  HomeScreen(this.databaseAPI);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Finance Course')),
      body: FutureBuilder<List>(
        future: databaseAPI.getLessons(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          final lessons = snapshot.data!;
          return ListView.builder(
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              return LessonListItem(lesson: lessons[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/feedback');
        },
        child: Icon(Icons.feedback),
        tooltip: 'Give thoughts and feedback',
      ),
    );
  }
}