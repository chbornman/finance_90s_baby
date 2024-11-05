import 'package:finance_90s_baby/api/auth_api.dart';
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
import 'screens/login_register_screen.dart';

void main() {
  LogService.instance.info("App started");
  WidgetsFlutterBinding.ensureInitialized();
  final client = Client()
      .setEndpoint(AppConstants.appwriteEndpoint) // Your Appwrite endpoint
      .setProject(AppConstants.projectId); // Your Appwrite project ID

  final databases = Databases(client);
  final storage = Storage(client);
  final authAPI = AuthAPI(client);

  runApp(MyApp(
    database: DatabaseAPI(databases),
    storage: StorageAPI(storage),
    authAPI: authAPI,
  ));
}

class MyApp extends StatefulWidget {
  final DatabaseAPI database;
  final StorageAPI storage;
  final AuthAPI authAPI;

  const MyApp({
    Key? key,
    required this.database,
    required this.storage,
    required this.authAPI,
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> isUserLoggedIn;
  String? userId; // Store the user ID

  @override
  void initState() {
    super.initState();
    isUserLoggedIn = _checkUserLoggedIn();
  }

  Future<bool> _checkUserLoggedIn() async {
    try {
      final user = await widget.authAPI.getCurrentUser();
      if (user != null) {
        userId = user.$id; // Save the user ID
        return true;
      }
    } catch (e) {
      if (e is AppwriteException && e.code == 401) {
        LogService.instance.info("User not logged in. Continuing as guest.");
      } else {
        LogService.instance.error("Unexpected error: $e");
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Course',
      theme: appTheme,
      home: FutureBuilder<bool>(
        future: isUserLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == true && userId != null) {
            // Pass userId to HomeScreen and set up routes
            return HomeScreen(widget.database, widget.storage);
          } else {
            return LoginRegisterScreen(
              widget.authAPI,
              onLoginSuccess: () {
                setState(() {
                  // Re-run the check to update the logged-in state and userId
                  isUserLoggedIn = _checkUserLoggedIn();
                });
              },
            );
          }
        },
      ),
      routes: {
        '/home': (context) => HomeScreen(widget.database, widget.storage),
        '/feedback': (context) {
          LogService.instance.info("Navigated to FeedbackScreen");
          return FeedbackScreen(widget.database, userId: userId!);
        },
        '/lesson': (context) => LessonScreen(
              userId: userId!,
              storageAPI: widget.storage,
              databaseAPI: widget.database,
              lesson: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),
      },
    );
  }
}
