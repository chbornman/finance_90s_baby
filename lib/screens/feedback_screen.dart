import 'package:finance_90s_baby/api/database_api.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final DatabaseAPI databaseAPI;

  FeedbackScreen(this.databaseAPI);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          decoration: InputDecoration(labelText: 'Your thoughts'),
          onSubmitted: (text) {
            databaseAPI.addComment('feedback', text);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}