import 'package:finance_90s_baby/api/auth_api.dart';
import 'package:finance_90s_baby/api/database_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LessonCommentSection extends StatefulWidget {
  final DatabaseAPI databaseAPI;
  final AuthAPI authAPI;
  final String lessonId;
  final String userId;

  LessonCommentSection({
    required this.databaseAPI,
    required this.authAPI,
    required this.lessonId,
    required this.userId,
  });

  @override
  _LessonCommentSectionState createState() => _LessonCommentSectionState();
}

class _LessonCommentSectionState extends State<LessonCommentSection> {
  late Future<List<Map<String, dynamic>>> _commentsFuture;
  late Future<String?> _lessonTitleFuture;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentsFuture = widget.databaseAPI.getAllLessonComments(widget.lessonId);
    _lessonTitleFuture = widget.databaseAPI.getLessonTitle(widget.lessonId);
  }

  void _addComment() async {
    final commentText = _commentController.text;
    if (commentText.isNotEmpty) {
      final userName = await widget.authAPI.getUserName();
      await widget.databaseAPI.addComment(
          widget.lessonId, widget.userId, userName ?? 'unknown', commentText);
      setState(() {
        _commentsFuture =
            widget.databaseAPI.getAllLessonComments(widget.lessonId);
      });
      _commentController.clear();
    }
  }

  String _formatTimestamp(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _lessonTitleFuture,
      builder: (context, lessonSnapshot) {
        if (lessonSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (lessonSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(child: Text('Error loading lesson title')),
          );
        } else {
          final lessonTitle = lessonSnapshot.data ?? 'Unknown Lesson';
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Flexible(
                    child: Text(
                      lessonTitle,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                            return FutureBuilder<String>(
                              future: comment['userName'] != null
                                  ? Future.value(comment['userName'])
                                  : Future.value('unknown'),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text('...'),
                                    ),
                                    title: Text('Loading...'),
                                    subtitle: Text(comment['comment']),
                                  );
                                } else if (userSnapshot.hasError) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text('?'),
                                    ),
                                    title: Text('Error'),
                                    subtitle: Text(comment['comment']),
                                  );
                                } else {
                                  final userName = userSnapshot.data!;
                                  return ListTile(
                                    leading: CircleAvatar(
                                      child: Text(userName[0].toUpperCase()),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(userName),
                                        SizedBox(width: 8),
                                        Text(
                                          _formatTimestamp(
                                              comment['timestamp']),
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(comment['comment']),
                                  );
                                }
                              },
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
      },
    );
  }
}
