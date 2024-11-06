import 'package:finance_90s_baby/api/database_api.dart';
import 'package:flutter/material.dart';
import 'comment_dialog.dart';

class CommentsScreen extends StatefulWidget {
  final DatabaseAPI databaseAPI;
  final String userId;

  CommentsScreen({required this.databaseAPI, required this.userId});

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommentDialog(
          getLessons: widget.databaseAPI.getLessons,
          addComment: widget.databaseAPI.addComment,
          userId: widget.userId,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _showCommentDialog(context),
          child: Text('Add Comment'),
        ),
      ),
    );
  }
}
