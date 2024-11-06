import 'package:finance_90s_baby/api/database_api.dart';
import 'package:flutter/material.dart';

class LessonCommentSection extends StatefulWidget {
  final DatabaseAPI databaseAPI;
  final String lessonId;
  final String userId;

  LessonCommentSection({
    required this.databaseAPI,
    required this.lessonId,
    required this.userId,
  });

  @override
  _LessonCommentSectionState createState() => _LessonCommentSectionState();
}

class _LessonCommentSectionState extends State<LessonCommentSection> {
  late Future<List<Map<String, dynamic>>> _commentsFuture;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentsFuture = widget.databaseAPI.getAllLessonComments(widget.lessonId);
  }

  void _addComment() async {
    final commentText = _commentController.text;
    if (commentText.isNotEmpty) {
      await widget.databaseAPI.addComment(widget.lessonId, widget.userId, commentText);
      setState(() {
        _commentsFuture = widget.databaseAPI.getAllLessonComments(widget.lessonId);
      });
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading comments'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No comments found'));
                } else {
                  final comments = snapshot.data!;
                  return ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      final comment = comments[index];
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(comment['userId'][0].toUpperCase()),
                        ),
                        title: Text(comment['userId']),
                        subtitle: Text(comment['comment']),
                        trailing: Text(
                          comment['timestamp'],
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Enter your comment',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
