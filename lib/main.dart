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
  String? userId;
  String userRole = 'user';

  @override
  void initState() {
    super.initState();
    isUserLoggedIn = _checkUserLoggedIn();
  }

  Future<bool> _checkUserLoggedIn() async {
    try {
      final user = await widget.authAPI.getCurrentUser();
      if (user != null) {
        userId = user.$id;
        final role = await widget.authAPI.getUserRole();
        setState(() {
          userRole = role ?? 'user';
        });
        return true;
      }
    } catch (e) {
      LogService.instance.error("Error: $e");
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
            return HomeScreen(
              widget.database,
              widget.storage,
              userRole: userRole,
              userId: userId!,
              authAPI: widget.authAPI,
            );
          } else {
            return LoginRegisterScreen(
              widget.authAPI,
              onLoginSuccess: () =>
                  Navigator.pushReplacementNamed(context, '/home'),
            );
          }
        },
      ),
      routes: {
        '/home': (context) => HomeScreen(
              widget.database,
              widget.storage,
              userRole: userRole,
              userId: userId!,
              authAPI: widget.authAPI,
            ),
        '/feedback': (context) {
          LogService.instance.info("Navigated to FeedbackScreen");
          return FeedbackScreen(widget.database, userId: userId!);
        },
        '/login': (context) => LoginRegisterScreen(
              widget.authAPI,
              onLoginSuccess: () =>
                  Navigator.pushReplacementNamed(context, '/home'),
            ),
      },
    );
  }
}
