import 'package:finance_90s_baby/api/database_api.dart';
import 'package:finance_90s_baby/api/storage_api.dart';
import 'package:finance_90s_baby/log_service.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'constants.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/lesson_screen.dart';

void main() {
  LogService.instance.info("App started");
  WidgetsFlutterBinding.ensureInitialized();

  Client client = Client();
  client
      .setEndpoint(AppConstants.appwriteEndpoint)
      .setProject(AppConstants.projectId);

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final Client client;

  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Course',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(DatabaseAPI(Databases(client))),
        '/feedback': (context) {
          LogService.instance
              .info("Navigated to FeedbackScreen"); // Log info message
          return FeedbackScreen(DatabaseAPI(Databases(client)));
        },
        '/lesson': (context) => LessonScreen(
              storageAPI: StorageAPI(Storage(client)),
              databaseAPI:
                  DatabaseAPI(Databases(client)), // Pass databaseAPI here
              lesson: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),
      },
    );
  }
}
