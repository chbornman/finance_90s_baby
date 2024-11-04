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
  final client = Client()
      .setEndpoint(AppConstants.appwriteEndpoint) // Your Appwrite endpoint
      .setProject(AppConstants.projectId); // Your Appwrite project ID

  final databases = Databases(client);
  final storage = Storage(client);

  runApp(MyApp(database: DatabaseAPI(databases), storage: StorageAPI(storage)));
}

class MyApp extends StatelessWidget {
  final DatabaseAPI database;
  final StorageAPI storage;

  const MyApp({Key? key, required this.database, required this.storage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Course',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
              database,
              storage,
            ),
        '/feedback': (context) {
          LogService.instance.info("Navigated to FeedbackScreen");
          return FeedbackScreen(database);
        },
        '/lesson': (context) => LessonScreen(
              storageAPI: storage,
              databaseAPI: database,
              lesson: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),
      },
    );
  }
}
