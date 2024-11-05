import 'package:finance_90s_baby/api/database_api.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  final DatabaseAPI databaseAPI;
  final String userId; // Add userId parameter

  const FeedbackScreen(this.databaseAPI, {super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: databaseAPI.getFeedback(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No feedback yet.'));
                }

                final feedbackList = snapshot.data!;
                return ListView.builder(
                  itemCount: feedbackList.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbackList[index];
                    return ListTile(
                      title: Text(feedback['comment']),
                      subtitle:
                          Text('User: ${feedback['userId'] ?? 'Anonymous'}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(labelText: 'Your thoughts'),
              onSubmitted: (text) {
                databaseAPI.addComment('feedback', userId, text);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
